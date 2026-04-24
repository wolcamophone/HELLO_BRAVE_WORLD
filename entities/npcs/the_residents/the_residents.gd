extends CharacterBody3D

@export var fly_speed:float = 4.0
@export var awareness_radius:float = 16
@export var lethality:bool = false

@onready var awareness_area_3d: Area3D = $AwarenessArea3D
@onready var awareness_shape_3d: CollisionShape3D = $AwarenessArea3D/CollisionShape3D
@onready var area_kill: AreaKill = $AreaKill

func _ready() -> void:
	self.add_to_group("npcs")
	
	awareness_shape_3d.shape.radius = awareness_radius
	if lethality == false:
		area_kill.hide()
	else:
		area_kill.show()


func _process(delta: float) -> void:
	if !awareness_area_3d.has_overlapping_areas():
		return
	
	for p in awareness_area_3d.get_overlapping_areas():
		if p.is_in_group("player"):
			fly_toward_target()

func fly_toward_target():
	look_at(GameMaster.active_player._collision.global_position)
	velocity = (GameMaster.active_player._collision.global_position - global_position).normalized() * fly_speed
	move_and_slide()
