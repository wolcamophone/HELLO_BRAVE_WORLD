extends StaticBody3D
class_name PropLight

@export var light_on:bool = true

@export var range:int = 24
@export var energy:int = 6
@export var color:Color = "ffffff" # White

#@onready var _audio_ambient_sfx: AudioAmbientSFX = $AudioAmbientSFX
@onready var _mesh: MeshInstance3D = $MeshInstance3D
@onready var _light: OmniLight3D = $OmniLight3D

func _ready():
	_light.omni_range = range
	_light.light_energy = energy
	_light.light_color = color
	update_light()

func toggle_light():
	light_on = !light_on
	update_light()

func update_light():
	if light_on:
		_light.visible = true
	elif !light_on:
		_light.visible = false
	
	if _mesh.get_active_material(1):
		if light_on:
			#_mesh.get_active_material(1).emission = "ffffff"
			pass
		elif !light_on:
			#_mesh.get_active_material(1).emission = "000000"
			pass
	elif !_mesh:
		print("prop_light.gd: Mesh did not initialize onready for node '%s', skipping emission change." % name)
