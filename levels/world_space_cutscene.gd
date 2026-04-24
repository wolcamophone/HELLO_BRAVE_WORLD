extends Node
class_name WorldSpaceCutscene

@export var main_camera:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	GameMaster.despawn_player()
	main_camera.current = true
