extends Node

### *AHEM* This node acts as one overarching manager to handle game events like player teleporting, saving/loading game data, and loading levels to drop the player into. To increase the modularity of OOP-scripting for other potential projects, and because singletons are not reached by get_tree(), this node should not hold too many important vars and instead should call to other children nodes in the scene for the data to pass into functions. -CD

signal level_loaded
signal game_loaded
signal game_saved
signal teleported
signal warped

@export_category("Game Master")
@export_group("Game Variables")
@export var NewGame:bool = false
@export var skip_intro_cutscene:bool = false

# Level Related Vars
var level_instance:Node3D
var level_previous:Node3D
var level_name_current:String

# Player Transporting Vars
var teleport_position:Vector3
var warp_destination:Node3D
var warp_position:Vector3

# Player Spawning Vars
var default_spawn_point:Node3D
var spawnpoints_available:Dictionary = {
	"xx-example-xx":Node3D,
}

# Checkpoint Vars
var checkpoint_current: Checkpoint
var checkpoint_current_name: String
var checkpoint_previous: Checkpoint
var checkpoint_previous_name: String
var checkpoints_available:Array

# Saving & Loading Vars
var save_game_path = "user://savegame_hbw.json"
var save_game_path_cfg = "user://savegame_hbw.cfg"
var load_data_dict:Dictionary = {}
var save_game_cfg:ConfigFile = ConfigFile.new()
var load_game_cfg:ConfigFile = ConfigFile.new()

@export_group("Environmental Variables")
@export var DefaultLerpVal: float = 0.2

@export_group("Player Variables")
@export var selected_player:PackedScene = preload("res://Player/android_033023.tscn")
var active_player:CharacterBody3D
@export var AltMoveMethod: bool = false
@export var ATTACK_POWER:float = 1
### If multiplayer is something we can integrate later, 
### players spawned in may need to be given ID's 
###	with a function and put into lists or something.

#@onready var MainMenu:CanvasLayer = $MainMenu
#@onready var HUD:CanvasLayer = $HUD
#@onready var AudioManager = $AudioManager


func _ready():
	DisplayServer.window_set_title("HELLO BRAVE WORLD!")
	DisplayServer.window_set_min_size(Vector2(600, 400))
	#MainMenu.title_button.visible = false
	print("HELLO BRAVE WORLD!")


func unload_level():
	### Remember to add a scene transition animation here -CD
	level_previous = level_instance
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null
	if active_player != null:
		active_player.queue_free()
	checkpoints_available.clear()
	spawnpoints_available.clear()


func load_level(level_name: String):
	await unload_level() # do this first off so the world space is made empty as not to stack levels on top of each other.

	var level_path = "res://levels/%s/%s.tscn" % [level_name, level_name]
	var level_resource = load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		get_tree().change_scene_to_file(level_path)
	elif !level_resource:
		printerr("Could not find level instance named" % level_name)

	# Hide the HUD if viewing intro cutscene or on boot menu.
	if level_name != "boot_menu" or level_name != "intro_cutscene":
		HUD.visible = true
		MainMenu.title_button.visible = true
	elif level_name == "boot_menu" or level_name == "intro_cutscene":
		HUD.visible = false
		MainMenu.title_button.visible = false

	# Show HUD if scene contains a WorldSpaceInfo
	if get_tree().get("WorldSpaceInfo"):
		HUD.visible = true
		MainMenu.title_button.visible = true

	#_ready() ### To refresh any objects outside of the level but still in game's runtime
	if level_instance: ### Printing a bunch of stuff to show scene tree for better debug
		print_tree_pretty()
		print(spawnpoints_available)
		#print_orphan_nodes()
		
		# Store all checkpoints found in the level into an array
		checkpoints_available = get_tree().get_nodes_in_group("checkpoint")
		
		### Once we are sure every bit of the level is prepped, then we
		spawn_player()
	
	print("Level loaded.")
	emit_signal("level_loaded")


func spawn_player():
### A player should always spawn in after a level loads to ensure there is a player. (Would be cool to hook around this so that loading into a new scene/level knows to spawn either a default player obj or a special player for minigame sections). If the func is called again while a player is already in the scene tree, they will be erased and recreated. -CD
	if active_player != null:
		active_player.queue_free()
	var p = selected_player.instantiate()
	add_child(p)
	p.top_level = true
	p.global_position = warp_position
	active_player = p
	print("Player respawn called.")

### Teleport targets a specific entity and retrieves rotation/position data from said entity to apply to the player. -CD
func teleport(tp_target):
	if tp_target:
		active_player.global_position = tp_target.global_position
		active_player._rotation_root.rotation.y = tp_target.rotation.y
		active_player._spring_arm.rotation.y = tp_target.rotation.y
		active_player._spring_arm.global_position = active_player._head.global_position # Avoid camera awkwardly zooping super fast back to player across level.
	else:
		printerr("Could not find tp target!")
		return


### Warp takes in a Vector3 of coordinates for the input and places the player at those coordinates. -CD
func warp(wp_position:Vector3, wp_rotation:int):
	if wp_position && wp_rotation:
		active_player.global_position = wp_position
		active_player._rotation_root.rotation.y = wp_rotation
		active_player._spring_arm.rotation.y = wp_rotation
		active_player._spring_arm.global_position = active_player._head.global_position # Avoid camera awkwardly zooping super fast back to player across level.
	else:
		printerr("Invalid warp coordinates given. Please provide a Vector3 for global position and ")
		return

### This function should aim to handle taking in anything with viable 3D coordinates and place the player there.
func teleport_new(target):
	if target is Vector4: # First values of Vector 4 correlate to XYZ positional values while fourth value W is the rotation in degrees.
		active_player.global_position.x = target.x
		active_player.global_position.y = target.y
		active_player.global_position.z = target.z
		active_player._spring_arm.rotation.y = target.w
		active_player._rotation_root.rotation.y = target.w
	elif target is Node3D:
		active_player.global_position = target.global_position
		active_player._spring_arm.rotation.y = target.rotation
		active_player._rotation_root.rotation.y = target.rotation
	else:
		printerr("Invalid target '%s' given for 'teleport_new()'. target should be a Vector4 or Node3D." % target)
		return
	
	active_player._spring_arm.global_position = active_player._head.global_position # Avoid camera awkwardly zooping super fast back to player across level.

#region SAVE FUNCTION COPIED FROM ENGINE DOCS. -CD
func save_game():
	print("Saving...")
	var game_save = FileAccess.open(save_game_path, FileAccess.WRITE)
	var saved_nodes = get_tree().get_nodes_in_group("persistent") + get_tree().get("WorldSpaceInfo")
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

	print("Saved game to ", save_game_path)

func save_game_as_cfg():
	print("Saving as cfg...")
	var saved_nodes = get_tree().get_nodes_in_group("persistent")
	for node in saved_nodes:
		# Check the node has a save function.
		if !node.has_method("save_cfg"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		# Call the node's save function.
		node.call("save_cfg")
		save_game_cfg.save(save_game_path_cfg)
	print("Saved game as cfg to ", save_game_path_cfg)
#endregion

#region LOAD FUNCTIONS REWRITTEN FROM GROUND UP AFTER ENGINE DOCS. -CD
func load_game():
	print("Loading...")
	
	if not FileAccess.file_exists(save_game_path):
		print("No save game file was found to load.")
		return
	
	### Open the file to read and store path in a var, convert path to text var, convert the text var back into JSON data, close file and use that JSON var to retrieve data from. -CD
	else:
		var save_file_for_loading = FileAccess.open(save_game_path, FileAccess.READ)
		# Loop through lines of JSON file.
		while save_file_for_loading.get_position() < save_file_for_loading.get_length():
			var json_string = save_file_for_loading.get_line()
			var json_inst:JSON = JSON.new()
			var load_data_loaded = json_inst.parse(json_string)
			if not load_data_loaded == OK:
				print("JSON Parse Error: ", json_inst.get_error_message(), " in ", json_string, " at line ", 
				json_inst.get_error_line())
				continue
			
			load_data_dict = json_inst.data
			print(load_data_dict) # Debug
			
			### Now we set the variables in the current game to match what is in the save file by running an IF through the loop to match appropriate data. 'i' is each line stored into load_data_dict. -CD
			GameMaster.active_player.global_position.x = load_data_dict.get("pos_x")
			GameMaster.active_player.global_position.y = load_data_dict.get("pos_y")
			GameMaster.active_player.global_position.z = load_data_dict.get("pos_z")
			
			
		### Close the file to save on space.
		save_file_for_loading.close()
	print("Finished Loading!")

func load_game_2():
	print("Loading...")
	if !FileAccess.file_exists(save_game_path):
		print("No save game file was found at ", save_game_path)
		return
	
	### I pulled my goddamn hair out over this func to get it to work so here we go! -CD
	var save_file_for_loading = FileAccess.open(save_game_path, FileAccess.READ) # Open file.
	var json_string = save_file_for_loading.get_line() # Convert to string.
	save_file_for_loading.close() # Close file now that we're done to save memory.
	print(json_string) # Debug.
	
	var json_inst = JSON.new() # Create an instance of JSON cause you can't call non-static parse() on JSON directly aside from parse_string(). Still with me?
	var error = json_inst.parse(json_string)
	if error:
		print("JSON Parse Error: ", json_inst.get_error_message(), " in ", json_string, " at line ", json_inst.get_error_line())
		return
	
	#GameMaster.active_player.global_position.x = load_data_dict.player_save_data.pos_x
	print("Finished Loading!")

func load_game_from_cfg():
	var load_game_data = load_game_cfg.load(save_game_path_cfg)
	
	if load_game_data == OK:
		load_level(load_game_cfg.get_value("Level", "level"))
		warp(load_game_cfg.get_value("Android", "position"), load_game_cfg.get_value("Android", "rotation"))
	

#endregion

### This is a generic func to be placed in other nodes within the group "persistent." As it currently stands, the save_game func only reaches out to child nodes in the tree, so this dict below and any other save funcs as a scene don't get written to the save file. -CD
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

func save_as_cfg():
	GameMaster.save_game_cfg.set_value("Category", "example value", name)

func quit_game():
	get_tree().quit()
