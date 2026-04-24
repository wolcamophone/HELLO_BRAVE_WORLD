extends Node3D

@export var force:float = 24
@export_range(0, 1) var control:float = 1
@export var lethality:int = 0

@onready var area_3d: Area3D = $Area3D
@onready var lod_area_3d: Area3D = $LODArea3D
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
	# I set this up as a way to get the game to stop doing the random rotation unless the player is close enough to see the effect, hopefully to save on CPU performance. Idk how well this effect actually works though. Looking into a shader that achieves this same twirling texture effect would be cool so it can use the GPU instead.
	if !lod_area_3d.has_overlapping_areas(): 
		return
	
	for p in lod_area_3d.get_overlapping_areas():
		if p.is_in_group("player"):
			_mesh_rotation()

func _rand_mesh_rotation(): # Visual effect/Cosmetic function
	mesh_pad.rotation_degrees.z = randi_range(0, 360)

func _mesh_rotation():
	mesh_pad.rotation_degrees.z = wrapi(rotation_degrees.z + 13, 0, 360)
