extends Area3D
class_name AreaKill

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("kill"):
		body.call("kill")

func _on_area_entered(area: Area3D) -> void:
	if area.has_method("kill"):
		area.call("kill")
