@icon("res://Graphics/UI/worldspaceinfo.png")
extends Node3D
class_name WorldSpaceInfo

@export var lvl_title:String = ""
@export var lvl_description:String = "This is a level description for a level for HELLO BRAVE WORLD."

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
	pass

func save():
	var save_dict = {
		"level_name_current" : name
	}
	return save_dict
