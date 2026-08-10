extends Node

@export_category("UI Sound")
@export var Hover: AudioStreamPlayer

@onready var UI_SELECT: AudioStreamPlayer = $UI_SELECT

func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.finished.connect()
	add_child(instance)
	instance.play()

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
