extends Node3D

@onready var platform: CharacterBody3D = $Platform
@onready var Pos1: Marker3D = $Pos1
@onready var Pos2: Marker3D = $Pos2

func _ready():
	platform.set_position(Pos1.get_position())
	move_platform()

func move_platform():
	var plat_tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_loops()
	plat_tween.tween_property(platform, "position", Pos1.get_position(),5).set_delay(.2)
	plat_tween.tween_property(platform, "position", Pos1.get_position(),5).set_delay(.2)
