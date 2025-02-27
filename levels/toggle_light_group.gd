extends Node

@export var light_group_active:bool = false

func _ready():
	for PropLight in get_children():
		PropLight._light.visible = light_group_active

func toggle_lights():
	light_group_active = !light_group_active
	for PropLight in get_children():
		PropLight._light.visible = light_group_active
