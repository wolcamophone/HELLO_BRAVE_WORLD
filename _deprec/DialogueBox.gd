extends PanelContainer

@onready var dialogue_box: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var VBox:VBoxContainer = $VBoxContainer
var choice_button_scn = preload("res://Scripts/UI/dialogue_button.tscn")
var choice_buttons:Array[Button] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	#get_tree().paused = true
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func clear_dialogue_box():
	dialogue_box.text = ""
	for choice in choice_buttons:
		VBox.remove_child(choice)
	choice_buttons = []

func add_text(text_to_display: String):
	dialogue_box.text = text_to_display

func add_choice(choice_text: String):
	var button_obj: DialogueButton = choice_button_scn.instantiate()
	button_obj.choice_index = choice_buttons.size()
	choice_buttons.push_back(button_obj)
	button_obj.text = choice_text
	button_obj.choice_selected.connect(_on_choice_selected)
	VBox.add_child(button_obj)

func _on_choice_selected(choice_index: int):
	print(choice_index)
	($"../EzDialogue" as EzDialogue).next(choice_index)
	
