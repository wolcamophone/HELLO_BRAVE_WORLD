extends SpringArm3D

@export var mouse_sensitivity = 5
@export var controller_sensitivity = 5
@export var cam_upper_limit = -65
@export var cam_lower_limit = 60
@export var zoom_toggled:bool = false

@onready var FOV = $Camera3D.fov

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity * 0.05
		rotation_degrees.y -= event.relative.x * mouse_sensitivity * 0.05
#		rotation_degrees.x -= event.relative.y * controller_sensitivity_vertical * 0.1
#		rotation_degrees.y -= event.relative.x * controller_sensitivity_horizontal * 0.1
#	rotation_degrees.x = clamp(rotation_degrees.x, cam_upper_limit, cam_lower_limit)
#	rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)


func _process(delta):
	rotation_degrees.x = clamp(rotation_degrees.x, cam_upper_limit, cam_lower_limit)
	rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)

func _physics_process(delta):
	if Input.is_action_pressed("look_up"):
		rotation_degrees.x += controller_sensitivity * 0.5
	if Input.is_action_pressed("look_down"):
		rotation_degrees.x -= controller_sensitivity * 0.5
	if Input.is_action_pressed("look_left"):
		rotation_degrees.y += controller_sensitivity * 0.5
	if Input.is_action_pressed("look_right"):
		rotation_degrees.y -= controller_sensitivity * 0.5



	if Input.is_action_just_pressed("cam_zoom"):
		print("zoom toggled")
		if zoom_toggled:
			zoom_toggled = true
		elif not zoom_toggled:
			zoom_toggled = false
	if zoom_toggled:
		spring_length = 8
		FOV = 70
	elif not zoom_toggled:
		spring_length = 4
		FOV = 80

		# Zooming
	
#	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
#	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
