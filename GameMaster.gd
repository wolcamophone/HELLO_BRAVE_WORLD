extends Node
### This node acts as one overarching manager to load in data like saves and settings, 
### as well as be able to load levels to drop the player into.
@export_category("Game Master")
@export_group("Game Variables")
@export var NewGame:bool = false
@export var ViewBob:bool = true
var level_instance:Node3D
var level_previous:Node3D
var teleport_position:Vector3
var warp_destination:Node3D
var warp_position:Vector3
var checkpoint_current: Checkpoint
var checkpoint_current_name: String
var checkpoint_previous: Checkpoint
var checkpoint_previous_name: String
var checkpoints_available:Dictionary = {
	"xx-example-xx":Node3D,
}
var default_spawn_point:Node3D
var spawnpoints_available:Dictionary = {
	"xx-example-xx":Node3D,
}


@export_group("Cheats")
@export var godmode:bool = false

@export_group("Environmental Variables")
@export var DayTime:bool = true
@export var DefaultLerpVal: float = 0.2

@export_group("Player Variables")
@export var selected_player:PackedScene = preload("res://Player/android_033023.tscn")
var active_player:CharacterBody3D
@export var AltMoveMethod: bool = false
@export var ATTACK_POWER:float = 1
###	If multiplayer is something we can integrate later, 
### players spawned in may need to be given ID's 
###	with a function and put into lists or something.

#@onready var MainMenu:CanvasLayer = $MainMenu
#@onready var HUD:CanvasLayer = $HUD
#@onready var AudioManager = $AudioManager


func _ready():
	DisplayServer.window_set_title("HELLO BRAVE WORLD!")
	DisplayServer.window_set_min_size(Vector2(800,600))
	#MainMenu.title_button.visible = false
	print("HELLO BRAVE WORLD!")


func unload_level():
	### Remember to add a scene transition here -CD
	level_previous = level_instance
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	if active_player:
		active_player.queue_free()
	checkpoints_available.clear()
	spawnpoints_available.clear()


func load_level(level_name: String):
	unload_level() 
	### vvv  Process of Instantiation  vvv
	var level_path = "res://levels/%s/%s.tscn" % [level_name, level_name]
	var level_resource = load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		get_tree().change_scene_to_file(level_path)
		#add_child(level_instance) # Does not work to current structure.
	elif !level_resource:
		print("Error! Could not find level instance named" % level_name)
	if level_name != "boot_menu":
		HUD.visible = true
	elif level_name == "boot_menu":
		HUD.visible = false	
	_ready() ### To refresh any objects outside of the level but still in game's runtime
	if level_instance: ### Printing a bunch of stuff to show scene tree for better debug
		print_tree_pretty()
		print(spawnpoints_available)
		#print_orphan_nodes()
		
		### Once we are sure every bit of the level is prepped, then we
		spawn_player()
	warp_destination = null


func spawn_player():
	### A player should always spawn in after a level loads to ensure there is a player.
	### (Would be cool to hook around this so that loading into a new scene/level knows
	### to spawn either a default player obj or a special player for minigame sections)
	### If the func is called again while a player is already in the scene tree, they will
	### be erased and recreated. -CD
	if active_player:
		active_player.queue_free()
	var p = selected_player.instantiate()
	p.top_level = true
	p.global_position = warp_position
	add_child(p)
	active_player = p
	print("Player respawn called")


func teleport(tp_target):
	### Teleport should be used only to move the player or an entity instantaneously
	### to a new position in the scene. If the player wants to go to a specific
	### entity, they should use warp. -CD
	if tp_target:
		active_player.global_position = tp_target.global_position
		active_player._spring_arm.global_position = active_player._head.global_position
	else:
		print("Error! Could not find tp target")


func warp(warp_destination:Node3D):
	if warp_destination:
		active_player.global_position = warp_destination.global_position
	else:
		print("No warp target set or found, spawning player at global origin.")


###	SAVE AND LOAD FUNCTIONS COPIED FROM ENGINE DOCS -CD
func save_game():
	print("Saving...")
	var game_save = FileAccess.open("user://savegame_hbw.save", FileAccess.WRITE)
	var saved_nodes = get_tree().get_nodes_in_group("persistent")
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
	print("Loading...")
	if not FileAccess.file_exists("user://savegame_hbw.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("persistent")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var game_save = FileAccess.open("user://savegame_hbw.save", FileAccess.READ)
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
		#get_node(node_data["parent"]).add_child(new_object)
	
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
				continue
			new_object.set(i, node_data[i])
			active_player.position = Vector3(node_data["pos_x"],node_data["pos_y"],node_data["pos_z"])
			print(node_data.keys())
		#load_level()

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"level_instance" : level_instance,
		"level_previous" : level_previous,
		"checkpoint_current" : checkpoint_current,
		"checkpoint_previous" : checkpoint_previous,
	}
	return save_dict

func quit_game():
	get_tree().quit()
