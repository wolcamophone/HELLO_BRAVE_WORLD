extends StaticBody3D

@export var radio_tune:AudioStream
@export var autoplay:bool = false

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_3d.stream = radio_tune
	
	if autoplay && radio_tune != null:
		audio_stream_player_3d.play()
