extends Node3D
class_name RandomChanceSpawner

@export_range(0,100) var percent_chance_to_spawn:int = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_spawn_chance()
	self.add_to_group("random_chance_spawner")

func test_spawn_chance() -> void:
	var chance:int = randi_range(1,100)
	if chance > percent_chance_to_spawn:
		queue_free()
