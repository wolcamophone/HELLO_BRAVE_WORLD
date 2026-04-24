extends Node3D
class_name ScoreLock ## Class of advanced Lock and conditional checks that allows various options for applied operands to values in ScoreCounter.

signal lock_passed

@export var persistent_lock:bool = false ## Should this lock remain unlocked after loading a saved game?

@export var is_locked:bool = true

@export var tied_locked_entity:Node3D

# These could probably be set up as a dict if you ever wanted to create more values in ScoreCounter to make comparisons against
@export_category("Coins")
@export var coin_locked:bool
@export var coin_sentinel:int
@export_enum("==", "-", "+", ">", "<",) var coin_operand:String = "==" ## Operand used to compare against value in ScoreCounter or determine what action to take against the existing value.

@export_category("Red Coins")
@export var red_coin_locked:bool
@export var red_coin_sentinel:int
@export_enum("==", "-", "+", ">", "<",) var red_coin_operand:String = "==" ## Operand used to compare against value in ScoreCounter or determine what action to take against the existing value.

@export_category("Lives")
@export var lives_locked:bool
@export var lives_sentinel:int
@export_enum("==", "-", "+", ">", "<",) var lives_operand:String = "==" ## Operand used to compare against value in ScoreCounter or determine what action to take against the existing value.

@onready var gui_score_lock: Control = $SubViewport/gui_score_lock
@onready var correct_bell: AudioStreamPlayer3D = $correct_bell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_display()

func query_lock() -> bool:
	if coin_locked == true:
		if coin_operand == "==":
			if ScoreCounter.coins == coin_sentinel:
				coin_locked = false
		if coin_operand == "-":
			ScoreCounter.coins -= coin_sentinel
			coin_locked = false
		if coin_operand == "+":
			ScoreCounter.coins += coin_sentinel
			coin_locked = false
		if coin_operand == ">":
			if ScoreCounter.coins > coin_sentinel:
				coin_locked = false
		if coin_operand == "<":
			if ScoreCounter.coins < coin_sentinel:
				coin_locked = false
		
	if red_coin_locked == true:
		if red_coin_operand == "==":
			if ScoreCounter.coins == red_coin_sentinel:
				red_coin_locked = false
		if red_coin_operand == "-":
			ScoreCounter.coins -= red_coin_sentinel
			red_coin_locked = false
		if red_coin_operand == "+":
			ScoreCounter.coins += red_coin_sentinel
			red_coin_locked = false
		if red_coin_operand == ">":
			if ScoreCounter.coins > red_coin_sentinel:
				red_coin_locked = false
		if red_coin_operand == "<":
			if ScoreCounter.coins < red_coin_sentinel:
				red_coin_locked = false
	
	if lives_locked == true:
		if lives_operand == "==":
			if ScoreCounter.coins == lives_sentinel:
				lives_locked = false
		if lives_operand == "-":
			ScoreCounter.coins -= lives_sentinel
			lives_locked = false
		if lives_operand == "+":
			ScoreCounter.coins += lives_sentinel
			lives_locked = false
		if lives_operand == ">":
			if ScoreCounter.coins > lives_sentinel:
				lives_locked = false
		if lives_operand == "<":
			if ScoreCounter.coins < lives_sentinel:
				lives_locked = false

	# Final Check to see if locks pass.
	if coin_locked == false && red_coin_locked == false && lives_locked == false:
		is_locked == false
		emit_signal("lock_passed")
		correct_bell.play()
		return false
	else:
		return true

func update_display() -> void:
	if !coin_locked:
		gui_score_lock.panel_1.modulate.a = 1
		gui_score_lock.label_value_1.text = ""
		gui_score_lock.label_operand_1.text = ""
	elif coin_locked:
		gui_score_lock.panel_1.modulate.a = 0
		gui_score_lock.label_value_1.text = str(coin_sentinel)
		gui_score_lock.label_operand_1.text = coin_operand
	
	if !red_coin_locked:
		gui_score_lock.panel_2.modulate.a = 1
		gui_score_lock.label_value_2.text = ""
		gui_score_lock.label_operand_2.text = ""
	elif red_coin_locked:
		gui_score_lock.panel_2.modulate.a = 0
		gui_score_lock.label_value_2.text = str(red_coin_sentinel)
		gui_score_lock.label_operand_2.text = red_coin_operand
	
	if !lives_locked:
		gui_score_lock.panel_3.modulate.a = 1
		gui_score_lock.label_value_3.text = ""
		gui_score_lock.label_operand_3.text = ""
	elif lives_locked:
		gui_score_lock.panel_3.modulate.a = 0
		gui_score_lock.label_value_3.text = str(lives_sentinel)
		gui_score_lock.label_operand_3.text = lives_operand
