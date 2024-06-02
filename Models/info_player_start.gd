class_name InfoPlayerStart
extends Node3D

@export var default_spawn_point:bool
@export var warpable_name:String  = ""

func _ready():
	visible = false
	GameMaster.spawn_player()
