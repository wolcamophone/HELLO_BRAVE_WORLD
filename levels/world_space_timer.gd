extends Node

@export var timescale:float = 1.0
@export var date_time:int = 0
@export var ticks_per_second:int = 6 

var delta_time:float = 0
var delta_int_seconds:int = 0

@export_range(0,59) var seconds:int = 0
@export_range(0,59) var minutes:int = 0
@export_range(0,23) var hours:int = 0
@export_range(0,29) var days:int = 0
@export_range(0,11) var months:int = 0
@export var years:int = 0

var clock:Dictionary = {
	"seconds" : seconds,
	"minutes" : minutes,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta_seconds: float) -> void:
	delta_time = delta_seconds
	if delta_time < 1:
		return
