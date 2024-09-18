extends StaticBody3D

@onready var music:AudioStreamPlayer3D = $music
@onready var meow:AudioStreamPlayer3D = $meow

func _on_area_3d_activation() -> void:
	music.stop()
	meow.play()
	print("You found Maxwell!")
