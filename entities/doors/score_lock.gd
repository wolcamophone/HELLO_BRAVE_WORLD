extends Node3D
class_name ScoreLock ## Class of advanced Lock and conditional checks that allows various options for applied operands to values in ScoreCounter.

signal lock_passed

@export var persistent_lock:bool = false ## Determine

# These could probably be set up as a dict if you ever wanted to create more values in ScoreCounter to make comparisons against
@export_category("Coins")
@export var coin_locked:bool
@export var coin_value:int
@export_enum("=", "-", "+", ">", "<",) var coin_operand = 0 ## Operand used to compare against value in ScoreCounter or determine what action to take against the existing value.

@export_category("Red Coins")
@export var red_coin_locked:bool
@export var red_coin_value:int
@export_enum("=", "-", "+", ">", "<",) var red_coin_operand = 0 ## Operand used to compare against value in ScoreCounter or determine what action to take against the existing value.

@export_category("Lives")
@export var lives_locked:bool
@export var lives_value:int
@export_enum("=", "-", "+", ">", "<",) var lives_operand = 0 ## Operand used to compare against value in ScoreCounter or determine what action to take against the existing value.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func query_lock():
	if coin_locked == true && ScoreCounter.COINS == coin_value:
		coin_locked = false
	if red_coin_locked == true && ScoreCounter.RED_COINS == red_coin_value:
		red_coin_locked = false
	if lives_locked == true && ScoreCounter.LIVES == lives_value:
		lives_locked = false
	
	if coin_locked == false && red_coin_locked == false && lives_locked == false:
		emit_signal("lock_passed")
		return false
	else:
		return true
