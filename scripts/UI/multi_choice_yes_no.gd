extends Node

signal selected_yes
signal selected_no

@export var prompt_text:String = ""

@onready var button_no: Button = $PanelContainer/VBoxContainer/HBoxContainer/ButtonNo
@onready var button_yes: Button = $PanelContainer/VBoxContainer/HBoxContainer/ButtonYes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_no.pressed.connect(sel_no)
	button_yes.pressed.connect(sel_yes)
	close_menu()

func sel_no():
	emit_signal("selected_no")

func sel_yes():
	emit_signal("selected_yes")

func show_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.visible = true

func close_menu():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
