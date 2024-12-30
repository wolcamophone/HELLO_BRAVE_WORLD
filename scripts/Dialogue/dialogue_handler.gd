extends Node
class_name DialogueContainer

@export var text_entered_array:PackedStringArray # Testing: functionality for an array of strings entered in editor

var text_entered = " ".join(text_entered_array)

@export_file("*.txt") var text_file # Testing: importing strings from a text file

@export var use_text_file:bool = false 

var text_to_display:Array # Chunks of text to be pushed into the HUD.display_box
var text_counter:int = 0 # Increments to text_to_display's array index

var dialogue_active:bool = false # flag to freeze the player when dialogue box is on screen
@export var pause_during_dialogue:bool = false



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func trigger_dialogue(): # TODO: continue adding functionality, then route inputs and events
	print("Dialogue triggered")
	dialogue_active = true

	if dialogue_active:
		HUD._dialogue_text = text_to_display[3]
		HUD._dialogue_container.visible = true
		
	if pause_during_dialogue && dialogue_active:
		get_tree().paused = true
	
	text_counter += 1
	
	if text_counter > text_to_display.size():
		end_dialogue()

	

func _process(delta: float) -> void:
	pass

func end_dialogue():
	text_counter = 0
	dialogue_active = false
	HUD._dialogue_text = null
	HUD._dialogue_container.visible = false
	if pause_during_dialogue && dialogue_active:
			get_tree().paused = false
