extends CanvasLayer

@export var dialogue_json: JSON
@export var display_health:int = 8

#@onready var state = {}
@onready var _health_bar = $Control/HealthBar
@onready var _coin_counter: Label = $Control/CoinCounter
@onready var _coin_counter_red: Label = $Control/CoinCounterRed
@onready var _lives_counter: Label = $Control/LivesCounter

@onready var _interact_text:Control = $Control/Diaract/BottomHalf/HBoxContainer/InteractText
@onready var _interact_prompt:Control = $Control/Diaract/BottomHalf/HBoxContainer
@onready var _fade_transitioner:AnimationPlayer = $Control/FadeTransition
@onready var _fade_block:ColorRect = $Control/ShaderRect
@onready var _dialogue_container:Control = $Control/Diaract/TopHalf/MarginContainer
@onready var _dialogue_text: RichTextLabel = $Control/Diaract/TopHalf/MarginContainer/RichTextLabel
@onready var _vignette: TextureRect = $Control/Vignette
@onready var _loading_label: Label = $Control/LoadingLabel
@onready var _saving_label: Label = $Control/SavingLabel

#@onready var display_health = get_node("Android033023").HEALTH

func _ready():
	print("HUD loaded!")
	_fade_block.visible = false
	_interact_prompt.visible = false
	_dialogue_container.visible = false
	_loading_label.visible = false
	_saving_label.visible = false

func _process(delta):
	_health_bar.value = display_health
	_coin_counter.text = "Coins: " + str(ScoreCounter.coins)
	_coin_counter_red.text = "Red Coins: " + str(ScoreCounter.red_coins)
	_lives_counter.text = "Lives: " + str(ScoreCounter.lives)

func scene_transition():
	pass
