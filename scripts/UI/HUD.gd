extends CanvasLayer

@export var dialogue_json: JSON
@export var display_health:int = 8

@export var show_debug_hud:bool = false

# Score Labels
@onready var _health_bar = $Control/HealthBar
@onready var _coin_counter: Label = $Control/HBoxScores/CoinCounter
@onready var _coin_counter_red: Label = $Control/HBoxScores/CoinCounterRed
@onready var _lives_counter: Label = $Control/HBoxScores/LivesCounter
@onready var _keys_counter: Label = $Control/HBoxScores/KeysCounter
@onready var _progress_bar_time_trial: TextureProgressBar = $Control/Diaract/TopHalf/ProgressBarTimeTrial

# Interaction Block
@onready var _interact_text:Control = $Control/Diaract/BottomHalf/HBoxContainer/InteractText
@onready var _interact_prompt:Control = $Control/Diaract/BottomHalf/HBoxContainer

# TODO: Fade animation nodes for the loading screen
@onready var _fade_transitioner:AnimationPlayer = $Control/FadeTransition
@onready var _fade_block:ColorRect = $Control/ShaderRect
@onready var _loading_label: Label = $Control/LoadingLabel
@onready var _saving_label: Label = $Control/SavingLabel

# deprec, Dialogic is used for dialogue instead: Dialogue Nodes 
@onready var _dialogue_container:Control = $Control/Diaract/TopHalf/MarginContainer
@onready var _dialogue_text: RichTextLabel = $Control/Diaract/TopHalf/MarginContainer/RichTextLabel

# Visual Effects and Overlays
@onready var _vignette: TextureRect = $Control/Vignette

# Debug
@onready var v_box_debug: VBoxContainer = $Control/VBoxDebug
@onready var _player_state: Label = $Control/VBoxDebug/PlayerState

# Health Bar
#@onready var display_health = get_node("Android033023").HEALTH

func _ready():
	print("HUD loaded!")
	_fade_block.visible = false
	_interact_prompt.visible = false
	_dialogue_container.visible = false
	_loading_label.visible = false
	_saving_label.visible = false
	v_box_debug .visible = false

func _process(delta):
	_health_bar.value = display_health
	_coin_counter.text = "Coins: " + str(ScoreCounter.coins)
	_coin_counter_red.text = "Packet Data: " + str(ScoreCounter.red_coins)
	_keys_counter.text = "Keygen: " + str(ScoreCounter.keys)
	_lives_counter.text = "Lives: " + str(ScoreCounter.lives)
	
	if show_debug_hud:
		_player_state.text = "GameMaster.active_player.current_state =  " + str(GameMaster.active_player.current_state)

func update_debug_vis():
	v_box_debug.visible = show_debug_hud

func scene_transition():
	pass
