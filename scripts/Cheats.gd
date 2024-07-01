extends Node

@export var slowmo_enabled:bool = false
@export var slowmo_timescale:float = 0.5

func slowmo():
	if slowmo_enabled:
		Engine.time_scale = slowmo_timescale
	elif !slowmo_enabled:
		Engine.time_scale = 1
