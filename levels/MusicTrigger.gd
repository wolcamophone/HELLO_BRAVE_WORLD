extends Area3D
class_name trigger_music

@onready var music:AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_area_entered(area):
	if area.is_in_group("player") and !music.playing:
		music.play()


