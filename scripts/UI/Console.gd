extends Control

@onready var text_output = $VBoxContainer/TextOutput
@onready var line_edit = $VBoxContainer/LineEdit

func _ready() -> void:
	_say()

func _say(push_line:String = ""):
	#text_output.text.append_text(push_line)
	pass
