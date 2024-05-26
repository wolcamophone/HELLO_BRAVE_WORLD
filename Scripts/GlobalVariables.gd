extends Node

#signal health_changed(new_health)

# This script will provide a space to add global variables and switches 
# that will affect the game world, such as quest flags and number of collectibles found.
@export_category("Game Variables")
@export var NewGame:bool = false

@export_category("Environmental Variables")
@export var DayTime:bool = true

@export_category("Player Variables")
@export var LIVES:int = 5
@export var KEYS:int = 0
@export var COINS:int = 0
@export var ATTACK_POWER:float = 1

@export_category("Quest Flags")
@export var TutorialBeaten:bool = false

func _ready():
	print("Global Variables loaded!")

#func take_damage(amount):
#	HEALTH -= amount
#	if HEALTH < 0:
#		HEALTH = 0
#
##	emit_signal("health_changed", HEALTH)
