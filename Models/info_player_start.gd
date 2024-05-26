extends Node3D
class_name InfoPlayerStart

@export var name_of_target:String  = ""

func _ready():
	visible = false
	GameMaster.spawn_player()
