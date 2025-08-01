extends Node3D

@export var force:float
@export var lethality:int

@onready var area_3d: Area3D = $Area3D
@onready var gleam: AudioStreamPlayer3D = $Gleam

func _on_area_3d_body_entered(body: Node3D) -> void:
	if  body.is_in_group("player"):
		body.velocity = (body.global_position - global_position) * force
		gleam.play()
		
		#print("anomaly detected!")
