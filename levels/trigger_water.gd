extends Area3D
class_name WaterArea3D

func _ready() -> void:
	add_to_group("water")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	pass

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Splash!")

func _on_area_exited(area):
	if area.is_in_group("player"):
		print("Splish!")
