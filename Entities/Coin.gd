extends Area3D

@onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _on_area_entered(area):
	ScoreCounter.COINS += 1
	visible = false
	AudioManager.UI_SELECT.play()
	queue_free()
