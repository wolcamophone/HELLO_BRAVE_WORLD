extends StaticBody3D
class_name PropLight

@export_enum("long", "short") var mesh_type = "short"
#@export var meshtype:ArrayMesh

@export var _range:int = 20
@export var _energy:int = 6

@onready var _meshtype_long: StaticBody3D = $Long
@onready var _meshtype_short: StaticBody3D = $Short
@onready var _light = $OmniLight3D

func _ready():
	_light.omni_range = _range
	_light.light_energy = _energy
	
	#_meshtype_long.visible = false
	#_meshtype_short.visible = false
	#
	#if mesh_type == 0:
		#_meshtype_long.visible = true
	#elif mesh_type == 1:
		#_meshtype_short.visible = true
