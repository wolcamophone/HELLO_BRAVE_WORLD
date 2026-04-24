extends AudioStreamPlayer3D
class_name AudioAmbientSFX ## Has a random chance to play an audio file after a set amount of time has passed.

@export_range(0,100,1) var playback_chance_percent:int = 64 ## Percent chance for the audio stream to be played.
@export var timer_interval: float = 1 ## Time in minutes to wait before next chance of playback.
var timer:Timer
var playback_rand_offset:float = randf_range(0, timer_interval/0.64 ) ## Staggers the starting timer so that multiple nodes don't overlap playback at once should they trigger.
@export var pitch_variance:float = 0.1 ## Adds randomness to pitch to make sounds more distinct and less repetative upon playback. Set to 0.0 to have all playback sound the same.
var pitch_scale_init = pitch_scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_interval = (timer_interval * 60) + playback_rand_offset
	
	timer = Timer.new()
	timer.timeout.connect(chance_playback)
	add_child(timer)
	
	start_audio()

func start_audio() -> void:
	timer.start(timer_interval)

func stop_audio() -> void:
	timer.stop()

func chance_playback() -> void: ## Picks a random value to determine if playback happens, then starts the timer over. 
	#print(name + ": chance called")
	var chance:int = 0
	chance = randi_range(0,100)
	if chance <= playback_chance_percent:
		pitch_scale = pitch_scale_init + randf_range(-pitch_variance, pitch_variance)
		play()
	else:
		stop()
	timer.start(timer_interval)
