extends Area3D
class_name AreaKill

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("kill"):
		body.call("kill")
	else:
		print("Body can't be killed.")
