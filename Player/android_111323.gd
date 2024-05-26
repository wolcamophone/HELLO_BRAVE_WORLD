extends RigidBody3D



@export var mouse_sensitivity: float = 1
@export var twist_input: float = 0.0
@export var pitch_input: float = 0.0



@onready var twist_pivot = $Head
@onready var pitch_pivot := $Head/Neck



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_lft", "move_rgt")
	input.z = Input.get_axis("move_fwd", "move_bwd")
	
	apply_central_force(twist_pivot.basis * input * 2000.0 * delta)
	
	var aligned_force = twist_pivot.basis * input
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity * 0.001
			pitch_input = - event.relative.y * mouse_sensitivity * 0.001
