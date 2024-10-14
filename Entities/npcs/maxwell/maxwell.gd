extends StaticBody3D

@onready var music:AudioStreamPlayer3D = $music
@onready var meow:AudioStreamPlayer3D = $meow
@onready var meshwell:MeshInstance3D = $Meshwell

@export var dangeresque:bool
var maxwell:int = 0

func _on_area_3d_activation() -> void:
	maxwell += 1
	if dangeresque:
		meow.pitch_scale += 0.006
		if maxwell > 68:
			get_tree().quit()
			# THAT'S RIGHT, IF YOU PET MAXWELL 69 TIMES YOUR GAME WILL FUCKING DIE.
	music.stop()
	meow.play()
	
	meshwell.rotate(Vector3.UP,randi_range(0,360))
	print("You found Maxwell!")
