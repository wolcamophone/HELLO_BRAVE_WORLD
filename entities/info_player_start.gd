extends Node3D
class_name InfoPlayerStart # Node that determines default spawn points for players.

@export var default_spawn_point:bool
@export var warpable_name:String  = ""
@export var team:String = "" # Testing: a generic name to pull for custom spawn handling conditionals/sorting

func _ready():
	visible = false
	if !GameMaster.level_transfer_destination && get_tree().get_nodes_in_group("InfoPlayerStart").size() < 2:
		GameMaster.default_spawn_point = self
		GameMaster.teleport(self)
		GameMaster.active_player._spring_arm.global_position = GameMaster.active_player._head.global_position

func register(): # Redirect: Should be called from the level's WorldSpaceInfo class node onready, if scene has one.
	if !warpable_name or warpable_name == "":
		GameMaster.spawnpoints_available[name] = self
	elif warpable_name:
		GameMaster.spawnpoints_available[warpable_name] = self
