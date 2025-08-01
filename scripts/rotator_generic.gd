extends Node3D ## Just throw this onto any Node3D to give it an adjustable constant rotational force.

@export var rotation_speed:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_degrees.y = randf_range(0, TAU)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees.y -= wrapf(rotation_speed * delta * 0.01, 0, 360)
