extends Area3D
class_name AreaHurt

signal damage_to_deal(damage)

@export var damage:int = 1
@export var blip:bool = 0
var thyme = Timer.new()

func _ready():
	thyme.start(0.1)

func _process(delta):
	if blip && thyme.timeout:
		queue_free()
