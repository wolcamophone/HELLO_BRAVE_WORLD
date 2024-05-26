extends MeshInstance

export var rotation_speed = 1

func _ready():
	rotation_degrees.y += rand_range(0, TAU)

func _physics_process(delta):
	rotation_degrees.y -= rotation_speed * delta * 0.5
