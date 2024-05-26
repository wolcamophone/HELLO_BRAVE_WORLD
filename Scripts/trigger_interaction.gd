class_name InteractionArea
extends Area3D

@export var prompt_text:String = "Activate"
@onready var area:Area3D 

var player_detected:bool = false

func _on_area_entered(area):
	if area.is_in_group("player"):
		player_detected = true
		HUD._interact_text = prompt_text
		HUD._interact_prompt.visible = true
func _on_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false
		HUD._interact_prompt.visible = false

