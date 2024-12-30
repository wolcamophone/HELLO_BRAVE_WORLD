extends Node3D

@export var force:float
@export var lethality:int

@onready var area_3d: Area3D = $Area3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if  body.is_in_group("player"):
		body.velocity.y += force
		print("anomaly detected!")
