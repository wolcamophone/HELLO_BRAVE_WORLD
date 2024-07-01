extends Node

@export_category("Scores")
@export var LIVES:int = 5
@export var KEYS:int = 0
@export var COINS:int = 0

func save():
	var save_dict = {
		"lives" : LIVES,
		"keys" : KEYS,
		"coins" : COINS,
	}
	return save_dict
