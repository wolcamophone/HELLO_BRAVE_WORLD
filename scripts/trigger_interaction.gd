extends Area3D
class_name AreaInteraction ## Area3D node with functionality for player interaction, HUD button prompt and text alteration. Requires a Collision3D like any other Area Node. Under Node tab above the Inspector, select "activation" signal and connect to an existing function in another node in the scene tree.

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
		display_prompt()
func _on_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false
		display_prompt()

func display_prompt():
	if !player_detected:
		HUD._interact_text.text = ""
		HUD._interact_prompt.visible = false
	elif player_detected:
		HUD._interact_text.text = prompt_text
		HUD._interact_prompt.visible = true

func _input(event):
	if player_detected && event.is_action_pressed("interact"):
		activation.emit()
