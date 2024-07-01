extends Node3D

func _ready():
	HUD.visible = false
	if GameMaster.active_player:
		GameMaster.active_player.queue_free()
