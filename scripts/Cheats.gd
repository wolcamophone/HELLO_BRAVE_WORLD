extends Node

### Welcome to the Cheats and Debugger funny settings script! -CD

@export var slowmo_enabled:bool = false
@export var slowmo_timescale:float = 0.5
@export var infinite_double_jumps:bool = false
@export var infinite_karma:bool = false ## Dying and running out of lives doesn't take the player to hell.

func slowmo() -> void:
	if slowmo_enabled:
		Engine.time_scale = slowmo_timescale
	elif !slowmo_enabled:
		Engine.time_scale = 1

func mod_score(score_to_mod, shmeckles) -> void:
	if score_to_mod == 0 or score_to_mod == "coins":
		ScoreCounter.coins += shmeckles
	elif score_to_mod == 1 or score_to_mod == "packet data":
		ScoreCounter.red_coins += shmeckles
	elif score_to_mod == 2 or score_to_mod == "keygen":
		ScoreCounter.keys += shmeckles
	elif score_to_mod == 3 or score_to_mod == "lives":
		ScoreCounter.lives += shmeckles

func inf_double_jumps() -> void:
	if !GameMaster.active_player.max_jump_count:
		return
	
	if infinite_double_jumps:
		GameMaster.active_player.max_jump_count = 999
	elif !infinite_double_jumps:
		GameMaster.active_player.max_jump_count = 1
