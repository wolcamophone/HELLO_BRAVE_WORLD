extends MeshInstance3D

@export var marker_color:Color

func _ready() -> void:
	visible = false
	#material_override.albedo_color = marker_color
	print("Info Marker Generic: %s, %s" % global_position, rotation_degrees)
	
