extends AudioStreamPlayer3D
class_name SoundEffectsPlayer3D ## Upgrade Class of AudioStreamPlayer3D with bonus parameters.

@export var pitch_variation:float = 0.1
var pitch_init:float = pitch_scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	finished.connect(change_pitch)

func change_pitch():
	pitch_scale = pitch_init + randf_range(-pitch_variation, pitch_variation)
