extends Control

var coin_locked:bool
var coin_operand:Array = ["=", "-", "+", ">", "<",]
var red_coin_locked:bool
var red_coin_operand:Array = ["=", "-", "+", ">", "<",]
var lives_locked:bool
var lives_operand:Array = ["=", "-", "+", ">", "<",]

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
