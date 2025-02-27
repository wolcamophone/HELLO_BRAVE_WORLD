extends Area3D
class_name MusicArea3D

@export var music:AudioStreamPlayer3D

func _ready() -> void:
	pass

func _on_area_entered(area):
	if area.is_in_group("player") and !music.playing:
		music.play()
