extends Marker3D
class_name SweepingRotator3D ## Makes nodes smoothly rotate around this pivot point, good for sweeping observers like security cameras or turrets.

@export var rotating:bool = true
@export var sweep_angle:int = 45
@export var sweep_speed:float = 1

var phase:float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	phase += delta
	wrapf(phase,0,TAU)
	
	if rotating:
		rotation_degrees.y = sin(phase * sweep_speed) * (sweep_angle/2)
		wrapf(rotation_degrees.y,0,360)
	elif !rotating:
		pass
