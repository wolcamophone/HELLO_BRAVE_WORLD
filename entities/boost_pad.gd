extends Node3D

@export var force:float = 24
@export_range(0, 1) var control:float = 1
@export var lethality:int = 0

@onready var area_3d: Area3D = $Area3D
@onready var gleam: AudioStreamPlayer3D = $Gleam
@onready var mesh_pad: MeshInstance3D = $MeshPad

func _on_area_3d_body_entered(body: Node3D) -> void:
	if  body.is_in_group("player"):
		#body.velocity.x = (global_position.x + body.global_position.x) * (force * control)
		#body.velocity.z = (global_position.z + body.global_position.z) * (force * control)
		body.velocity.y += force
		gleam.play()
		
		#print("anomaly detected!")

func _physics_process(delta: float) -> void:
	mesh_pad.rotation_degrees.z = randi_range(0, 360)
