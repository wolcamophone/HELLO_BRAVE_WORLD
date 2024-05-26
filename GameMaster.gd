extends Node
### This node acts as one overarching manager to load in data like saves and settings, 
### as well as be able to load levels to drop the player into.
@export_category("Game Master")
@export_group("Game Variables")
@export var NewGame:bool = false
@export var ViewBob:bool = true
@export_dir var sprite_folder_path: String
@export var level_instance:Node3D
@export var level_previous:Node3D
@export var warp_target:Node3D
var checkpoints_available 
@export var checkpoint_current: Checkpoint
@export var checkpoint_previous: Checkpoint

@export_group("Environmental Variables")
@export var DayTime:bool = true
@export var DefaultLerpVal: float = 0.2

@export_group("Player Variables")
@export var selected_player:PackedScene = preload("res://Player/android_033023.tscn")
@export var active_player:CharacterBody3D
@export var AltMoveMethod: bool = false
@export var ATTACK_POWER:float = 1
###	If multiplayer is something we can integrate later, 
### players spawned in may need to be given ID's 
###	with a function and put into lists or something.
@export_group("Scores")
@export var LIVES:int = 5
@export var KEYS:int = 0
@export var COINS:int = 0

#@export_group("Quest Flags")
@export var QuestFlags:Dictionary = {"Tutorial Beaten": false,
"_/~(^w^)~/": false}

#@export_group("Key Index")
@export var KeyIndex: Dictionary = {"Master Key": false,
"Tutorial Key": false}

#@onready var MainMenu:CanvasLayer = $MainMenu
#@onready var HUD:CanvasLayer = $HUD
#@onready var AudioManager = $AudioManager

@export_group("Spooky Numbers")
var random_float = randf()
var random_int_range = randi_range(69, 420)

func _ready():
	DisplayServer.window_set_title("HELLO BRAVE WORLD!")
	DisplayServer.window_set_min_size(Vector2(800,600))
	#MainMenu.title_button.visible = false
	print("HELLO BRAVE WORLD!")


func unload_level():
	### Remember to add a scene transition here -CD
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null


func load_level(level_name: String):
	level_previous = level_instance
	unload_level()
	var level_path = "res://Levels/%s.tscn" % level_name
	var level_resource = load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		get_tree().change_scene_to_file(level_path)
	else:
		print("Error! Could not find level instance named" % level_name)
	warp_target = find_child("Checkpoint")
	#print_orphan_nodes()
	if level_name != "boot_menu":
		HUD.visible = true
	elif level_name == "boot_menu":
		HUD.visible = false
	spawn_player()
	print_tree_pretty()
	_ready()


func spawn_player():
	warp_target = $"../Checkpoint"
	if active_player:
		active_player.queue_free()
	var playa = selected_player.instantiate()
	playa.top_level = true
	add_child(playa)
	if warp_target:
		playa.global_position = warp_target.global_position
	else:
		print("No warp target set or found, spawning player at global origin.")
	active_player = playa
	print("Player respawn.")


func teleport():
	if warp_target:
		get_tree().find_child("Android033023").position = warp_target.position
	else:
		print("Error! Could not find warp target named" % warp_target)



###	SAVE AND LOAD FUNCTIONS COPIED FROM ENGINE DOCS -CD
func save_game():
	var game_save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var saved_nodes = get_tree().get_nodes_in_group("Persist")
	for node in saved_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		game_save.store_line(json_string)


func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var game_save = FileAccess.open("user://savegame.save", FileAccess.READ)
	while game_save.get_position() < game_save.get_length():
		var json_string = game_save.get_line()
		# Creates the helper class to interact with JSON
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", 
			json.get_error_line())
			continue
		# Get the data from the JSON object
		var node_data = json.get_data()
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])


func quit_game():
	get_tree().quit()
