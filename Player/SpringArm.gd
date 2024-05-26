extends SpringArm

export var mouse_sensitivity = 7
export var clamp_top = -90
export var clamp_btm = 50

onready var _cam_pivot = $Position3D



func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _input(event: InputEvent):
#	rotation_degrees.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
#	rotation_degrees.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * (mouse_sensitivity * 0.01)
		rotation_degrees.y -= event.relative.x * (mouse_sensitivity * 0.01)
		
	rotation_degrees.x = clamp(rotation_degrees.x, clamp_top, clamp_btm)
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)



func _process(delta):
	pass
