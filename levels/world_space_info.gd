@icon("res://Graphics/UI/worldspaceinfo.png")
extends Node
class_name WorldSpaceInfo

### This class exists to house variables and other info for levels. 
### This class should be placed at the very bottom of the Scene Tree as a direct child so that it gets read first and saves the level name properly. Godot reads the Scene Tree from the bottom up. -CD

signal checkpoints_registered
signal spawnpoints_registered

@export var lvl_title:String = ""
@export_multiline var lvl_description:String = "This is a description for a level for HELLO BRAVE WORLD."
@export var default_spawn_position:Vector4 = Vector4(0,0,0,0) ## XYZ coordinates, followed by rotation in degrees.

@export_enum("Both", "Inside", "Outside") var environment_type = 0 # You can eventually hook environmental details into a check for this, such as default lighting or soundscape behavior.

#@onready var lvl_env:WorldEnvironment = $WorldEnvironment
#@onready var lvl_sun:DirectionalLight3D = $DirectionalLight3D
#@onready var lvl_map:FuncGodotMap = $FuncGodotMap
#@onready var lvl_def_spawnpoint:InfoPlayerStart = $InfoPlayerStart
#@onready var lvl_main_ambience = $AmbientTrack
#@onready var lvl_main_music:AudioStreamPlayer3D = $MusicTrack
#@onready var lvl_prop_static_collection:Node3D = $PropStatics
#@onready var lvl_entity_collection:Node3D = $Entities
#@onready var lvl_

func _ready() -> void:
	# Redirect: There is also code in the GM to check to see if the current scene is titled "boot_menu" or contains a WorldSpaceInfo node.
	HUD.visible = true
	self.add_to_group("persistent")
	self.add_to_group("WorldSpaceInfo")
	register_spawnpoints()
	register_checkpoints()
	print("WSI, spawnpoints_available SIZE: ", GameMaster.spawnpoints_available.size())
	print("WSI, spawnpoints_available ", GameMaster.spawnpoints_available)


func register_spawnpoints():
	InfoPlayerStart
	var checkpoints_possible = get_tree().get_nodes_in_group("InfoPlayerStart")
	for candidate in checkpoints_possible:
		if !candidate.has_method("register"):
			print("Node '%s' was not identified as proper Checkpoint." % candidate.name)
			continue
		
		candidate.call("register")
	
	print("WSI has called to register checkpoints.")
	emit_signal("spawnpoints_registered")

func register_checkpoints():
	Checkpoint
	var checkpoints_possible = get_tree().get_nodes_in_group("checkpoint")
	for candidate in checkpoints_possible:
		if !candidate.has_method("register"):
			print("Node '%s' was not identified as proper InfoPlayerStart." % candidate.name)
			continue
		
		candidate.call("register")
	
	print("WSI has called to register spawnpoints.")
	emit_signal("checkpoints_registered")


func save():
	var save_dict = {
			"level_name_current" : name,
			"level_instance" : GameMaster.level_instance,
			"level_previous" : GameMaster.level_previous,
			"checkpoint_current" : GameMaster.checkpoint_current,
			"checkpoint_previous" : GameMaster.checkpoint_previous,
	}
	return save_dict

func save_cfg():
	GameMaster.save_game_cfg.set_value("Level", "level", get_parent().name)
