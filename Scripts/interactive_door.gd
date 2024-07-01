class_name InteractiveDoor
extends StaticBody3D

@export var overwrite_prompt_text:String
@export var dynamic_to_save:bool 
@export var warp_door:bool
@export var transfer_to_level:String
@export var warp_to_position:Vector3

#@onready var door_model = 
@onready var trigger_zone = $InteractionArea
@onready var animation_player = $AnimationPlayer
@onready var sound = $AudioStreamPlayer3D

var open:bool = false
var player_detected:bool = false

func _ready():
	if open:
		animation_player.seek(0.6)
	if overwrite_prompt_text != null:
		trigger_zone.prompt_text = overwrite_prompt_text

func _on_area_3d_area_entered(area):
	if area.is_in_group("player"):
		player_detected = true
func _on_interaction_area_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false

func _input(event):
	if player_detected && event.is_action_pressed("interact"):
		sound.play()
		if !open:
			animation_player.play("Open")
		elif open:
			animation_player.play_backwards("Open")
		if !warp_door:
			open = !open
		elif warp_door:
			GameMaster.warp_position = warp_to_position
			GameMaster.load_level(transfer_to_level)

func save():
	if dynamic_to_save:
		var save_dict = {
			"filename" : get_scene_file_path(),
			"parent" : get_parent().get_path(),
			"open" : open
		}
		return save_dict
