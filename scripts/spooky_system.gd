extends Node

var thyme:Timer = Timer.new()

func _ready() -> void:
	print(" ( * ) ( * ) ")
	
	var d = randi() % 3
	if d == 2:
		OS.shell_open("C:/Users/Default/Pictures")


func _process(delta: float) -> void:
	pass
