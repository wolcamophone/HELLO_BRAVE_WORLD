extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var chance:int = randi_range(0,2)
	if chance > 1:
		queue_free()
