extends Node

@export var time_left:float
@export var time_set:float

@onready var timer:Timer = $Timer
@onready var sfx_buzzer: AudioStreamPlayer = $sfx_buzzer
@onready var sfx_ding: AudioStreamPlayer = $sfx_ding
@onready var sfx_ticking: AudioStreamPlayer = $sfx_ticking

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(end_time_trial)
	timer.one_shot = true
	#HUD._progress_bar_time_trial.visible = false

func begin_time_trial(with_time_amount:float):
	timer.start(with_time_amount)
	time_set = with_time_amount
	sfx_ticking.play()
	
	HUD._progress_bar_time_trial.visible = true
	#_update_event()
	
func end_time_trial(with_success:bool = false):
	timer.stop()
	sfx_ticking.stop()
	
	if with_success == true:
		sfx_ding.play()
	elif with_success == false:
		sfx_buzzer.play()
	
	HUD._progress_bar_time_trial.visible = false
	#_update_event()

func _process(delta: float) -> void:
	HUD._progress_bar_time_trial.value = (timer.time_left / time_set) * 100
	
#func _update_event():
	#if timer.time_left <= 0:
		#HUD._progress_bar_time_trial.visible = false
	#elif timer.time_left > 0:
		#HUD._progress_bar_time_trial.visible = true
