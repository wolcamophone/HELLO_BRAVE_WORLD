extends Node

@export var music:AudioStreamOggVorbis

func _on_area_entered(area):
	if area.is_in_group("player"):
		music.play()
