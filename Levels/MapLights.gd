extends Node

@export var light_group_active:bool = false

func _process(delta):
	for PropLight in get_children():
		PropLight._light.visible = light_group_active
