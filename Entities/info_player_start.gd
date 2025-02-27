extends Node3D

@export var default_spawn_point:bool
@export var warpable_name:String  = ""
@export var team:String = "" # Testing: a generic name to pull for custom spawn handling conditionals/sorting

func _ready():
	visible = false
	GameMaster.default_spawn_point = self
	GameMaster.teleport(self)
	GameMaster.active_player._spring_arm.global_position = GameMaster.active_player._head.global_position

func register_spawnpoint():
	GameMaster.spawnpoints_available[warpable_name] = self
