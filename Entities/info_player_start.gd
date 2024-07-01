extends Node3D

@export var default_spawn_point:bool
@export var warpable_name:String  = ""

func _ready():
	visible = false
	GameMaster.default_spawn_point = self
	GameMaster.active_player.global_position = self.global_position

func register_spawnpoint():
	GameMaster.spawnpoints_available[warpable_name] = self
