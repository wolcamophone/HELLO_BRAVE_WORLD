extends Node3D
class_name LightGroupToggle

@export var light_group_active:bool = false

func _ready():
	add_to_group("persistent")
	for PropLight in get_children():
		PropLight._light.visible = light_group_active

func toggle_lights():
	light_group_active = !light_group_active
	for PropLight in get_children():
		PropLight._light.visible = light_group_active
