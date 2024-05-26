extends StaticBody3D
class_name PropLight

@export_enum("long", "short", "circle") var _mesh_type = "short"

@export var _range:int = 16
@export var _energy:int = 8

@onready var _light = $OmniLight3D

func _process(delta):
	_light.omni_range = _range
	_light.light_energy = _energy
