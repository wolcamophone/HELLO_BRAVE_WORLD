extends Node
class_name DialogicPrompter

@export var dialogue_to_prompt: String
@export var pause_during_dialogue:bool = false
var dialogue_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # I added this so the game could pause during dialogue. -CD
	if dialogue_to_prompt == "" or dialogue_to_prompt == null:
		print("You forgot to set a dialogue file for ", get_parent())

func  _input(event: InputEvent) -> void:
	if dialogue_active && event.is_action_pressed("ui_cancel"):
		cancel_dialogue()

func trigger_dialogue():
	# Set dialogue being active based on if Dialogic has a timeline loaded.
	if Dialogic.current_timeline == null:
		dialogue_active = false
	elif Dialogic.current_timeline != null:
		dialogue_active = true
		
	# Check first to not restart the dialogue box if there's already one active, dumbass. -CD
	if dialogue_active == false:
		if dialogue_to_prompt != "" or dialogue_to_prompt != null:
			Dialogic.start(dialogue_to_prompt)
		elif dialogue_to_prompt == "" or dialogue_to_prompt == null:
			Dialogic.start("test_dialogue")

	# TODO: this currently doesn't work as it pauses Dialogic. Can't find a way to set it to PROCESS_MODE_ALWAYS. Even if I did, I suspect it would somehow trip the dialogue restarting bug again.
	#if pause_during_dialogue:
		#if !dialogue_active:
			#get_tree().paused = false
		#elif dialogue_active:
			#get_tree().paused = true

func cancel_dialogue():
	Dialogic.end_timeline()
