extends Control

var coin_locked:bool #= get_parent().get_parent().coin_locked
var coin_operand:Array = ["==", "-", "+", ">=", "<=",]
var red_coin_locked:bool #= get_parent().get_parent().red_coin_locked
var red_coin_operand:Array = ["==", "-", "+", ">=", "<=",]
var lives_locked:bool #= get_parent().get_parent().lives_locked
var lives_operand:Array = ["==", "-", "+", ">=", "<=",]

@onready var lock:Node3D = get_parent().get_parent()

@onready var panel_1: Panel = $TextureRect/HBoxContainer/VBoxIcons/Panel1
@onready var panel_2: Panel = $TextureRect/HBoxContainer/VBoxIcons/Panel2
@onready var panel_3: Panel = $TextureRect/HBoxContainer/VBoxIcons/Panel3

@onready var label_operand_1: Label = $TextureRect/HBoxContainer/VBoxOpperands/LabelOperand1
@onready var label_operand_2: Label = $TextureRect/HBoxContainer/VBoxOpperands/LabelOperand2
@onready var label_operand_3: Label = $TextureRect/HBoxContainer/VBoxOpperands/LabelOperand3

@onready var label_value_1: Label = $TextureRect/HBoxContainer/VBoxValues/LabelValue1
@onready var label_value_2: Label = $TextureRect/HBoxContainer/VBoxValues/LabelValue2
@onready var label_value_3: Label = $TextureRect/HBoxContainer/VBoxValues/LabelValue3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#update_display()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func update_display() -> void:
	#if !coin_locked:
		#panel_1.modulate.a = 1
		#label_value_1.text = ""
		#label_operand_1.text = ""
	#elif coin_locked:
		#panel_1.modulate.a = 0
		#label_value_1.text = lock.coin_sentinel
		#label_operand_1.text = coin_operand[lock.coin_operand]
	#
	#if !red_coin_locked:
		#panel_2.modulate.a = 1
		#label_value_2.text = ""
		#label_operand_2.text = ""
	#elif red_coin_locked:
		#panel_2.modulate.a = 0
		#label_value_2.text = lock.red_coin_sentinel
		#label_operand_2.text = lock.red_coin_operand
	#
	#if !lives_locked:
		#panel_3.modulate.a = 1
		#label_value_3.text = ""
		#label_operand_3.text = ""
	#elif lives_locked:
		#panel_3.modulate.a = 0
		#label_value_3.text = lock.lives_sentinel
		#label_operand_3.text = lock.lives_operand
