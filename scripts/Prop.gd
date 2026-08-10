extends RigidBody3D
class_name Prop

@onready var mesh: MeshInstance3D
@export_enum("Wood","Metal","Stone","Grass","Flesh") var sound_pack
@onready var Wood: AudioStreamPlayer3D = $Wood

func impact():
	if linear_velocity.x > 5:
		Wood.play()
