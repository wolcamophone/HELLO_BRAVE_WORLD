extends Area3D
class_name AreaScatterSpawn

@export var object_to_scatter:PackedScene ## Select a scene to be instanciated and spawned in this area, i.e. coins, enemies, grass prefabs. SELECT WISELY! Don't load anything crazy like entire levels.
@export var number_to_spawn:int = 5
@export var spawn_radius:int = 1 ## Max distance from the center of this area an object can spawn. 
@export var spawn_on_ready:bool = false

var random_location_picked:Vector3

func _ready() -> void:
	pass # Replace with function body.


func spawn_item(): ## Instanciate the object and spawn it at the random location.
	for i in number_to_spawn:
		var a = object_to_scatter.instantiate()
		add_child(a)
		a.global_position = self.global_position + Vector3(randi_range(-1,1),0,randi_range(-1,1))
		
