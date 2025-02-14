extends Node

### Welcome to the Cheats and Debugger funny settings script! -CD

@export var slowmo_enabled:bool = false
@export var slowmo_timescale:float = 0.5

func slowmo():
	if slowmo_enabled:
		Engine.time_scale = slowmo_timescale
	elif !slowmo_enabled:
		Engine.time_scale = 1

func mod_score(score_to_mod, shmeckles):
	var coin_mod
	var lives_mod
	if score_to_mod == coin_mod:
		ScoreCounter.COINS += shmeckles
