extends Node

@export_category("Scores")
@export var lives:int = 3
@export var keys:int = 0
@export var coins:int = 0
@export var red_coins:int = 0
@export var red_coins_max:int = 8

func reset_scores():
	lives = 3
	keys = 0
	coins = 0
	red_coins = 0
