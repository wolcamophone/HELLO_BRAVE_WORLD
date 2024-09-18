class_name InteractionArea
extends Area3D

signal activation

@export var prompt_text:String = "Activate"
@onready var area:Area3D 

var player_detected:bool = false

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	if area.is_in_group("player"):
		player_detected = true
		HUD._interact_text.text = prompt_text
		HUD._interact_prompt.visible = true
func _on_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false
		HUD._interact_prompt.visible = false

func _input(event):
	if player_detected && event.is_action_pressed("interact"):
		activation.emit()
