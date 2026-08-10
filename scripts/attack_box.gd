extends Area3D

@export var attack_persists:bool = true
var dir = Vector3()

func _process(delta):
	position -= transform.basis.z * 15 * delta

func _on_area_entered(area: Node):
	if area.is_in_group("Enemy") and !attack_persists:
		queue_free()

func _on_timer_timeout():
	queue_free()
