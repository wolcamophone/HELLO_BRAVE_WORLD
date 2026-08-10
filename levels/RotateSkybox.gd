extends WorldEnvironment

@export  var rotation_speed:float = 1.0

func _ready():
	pass
	environment.sky_rotation.y = randf_range(0, TAU)

func _physics_process(delta):
	environment.sky_rotation.y -= wrapf(rotation_speed * delta * 0.01, 0, 360)
