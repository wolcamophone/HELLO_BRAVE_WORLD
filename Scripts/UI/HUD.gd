extends CanvasLayer

@export var dialogue_json: JSON
@export var display_health:int = 8

#@onready var state = {}
@onready var _health_bar = $Control/HealthBar
@onready var _coin_counter = $Control/CoinCounter
@onready var _dialogue_box:PanelContainer = $Control/Diaract/Control/DialogueBox
@onready var _EzDialogueInst = $Control/EzDialogue
@onready var _interact_text = $Control/Diaract/Control2/HBoxContainer/InteractText
@onready var _interact_prompt = $Control/Diaract/Control2/HBoxContainer
@onready var _fade_transitioner = $Control/FadeTransition
@onready var _fade_block:ColorRect = $Control/ColorRect
#@onready var display_health = get_node("Android033023").HEALTH

func _ready():
	#self.visible = false
	print("HUD loaded!")
	_fade_block.visible = false
	_interact_prompt.visible = false
	#(_EzDialogueInst as EzDialogue).start_dialogue(dialogue_json, state)

func _process(update):
	_health_bar.value = display_health
	_coin_counter.text = "Coins: " + str(GameMaster.COINS)
	pass

func scene_transition():
	pass
	

func _on_ez_dialogue_dialogue_generated(response):
	_dialogue_box.clear_dialogue_box()
	_dialogue_box.add_text(response.text)
	
	for choice in response.choices:
		_dialogue_box.add_choice(choice)

