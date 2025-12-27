extends StaticBody3D
class_name SwitchType

signal button_activation

@export var toggleable:bool
@export var toggled:bool = false
@export var prompt_text:String = "Activate"
@export var broken:bool = false

@onready var button_model: Node3D = $ButtonModel
@onready var interaction_area: AreaInteraction = $InteractionArea
@onready var push_sound: AudioStreamPlayer3D = $PushSound
@onready var broken_sound: AudioStreamPlayer3D = $BrokenSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.prompt_text = prompt_text

func _on_activation() -> void:
	if !broken:
		toggled = !toggled
		push_sound.play()
		button_activation.emit()
	else:
		broken_sound.play()
		print("This switch is deactivated!")
