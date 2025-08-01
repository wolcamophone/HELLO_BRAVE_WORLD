extends SpringArm3D

@export var mouse_sensitivity:int = 5
@export var controller_sensitivity:int = 5
@export var cam_upper_limit:int = -75
@export var cam_lower_limit:int = 60
@export var zoom_level:int = 2

var ui_active:bool = false

@onready var camera = $Camera3D
@onready var shutter = $CamZoom

# Called when the node enters the scene tree for the first time.
func _ready():
	add_excluded_object(self.get_parent().get_parent())

func _input(event):
	if event is InputEventMouseMotion && ui_active == false:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity * 0.05
		rotation_degrees.y -= event.relative.x * mouse_sensitivity * 0.05

	if event.is_action_pressed("cam_zoom"):
		zoom_level += 1
		if zoom_level > 3:
			zoom_level = 1
		#print("Zoom Level: ",zoom_level)
		if zoom_level == 1:
			spring_length = 0
			camera.fov = (SettingsConfig.fov_desired) + 2
		elif zoom_level == 2:
			spring_length = 4
			camera.fov = SettingsConfig.fov_desired
		elif zoom_level == 3:
			spring_length = 6
			camera.fov = (SettingsConfig.fov_desired) - 2
		shutter.play()
	
	if event.is_action_pressed("look_up"):
		rotation_degrees.x += controller_sensitivity * 0.5
	if event.is_action_pressed("look_down"):
		rotation_degrees.x -= controller_sensitivity * 0.5
	if event.is_action_pressed("look_left"):
		rotation_degrees.y += controller_sensitivity * 0.5
	if event.is_action_pressed("look_right"):
		rotation_degrees.y -= controller_sensitivity * 0.5


func _process(delta):
	rotation_degrees.x = clamp(rotation_degrees.x, cam_upper_limit, cam_lower_limit)
	rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
	
	if MainMenu.visible == false and CheckpointMenu.visible == false:
		ui_active = false
	else:
		ui_active = true

func _physics_process(delta):
	pass

	
#	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
#	zoom = clamp(zoom, zoom_maximum, zoom_minimum)

func save_cfg():
	GameMaster.save_game_cfg.set_value("Android", "camera_rotation", rotation_degrees.y)
