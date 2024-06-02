extends Node3D

@export var tp_target:Node3D

func _on_interaction_area_activation():
	GameMaster.teleport(tp_target)
