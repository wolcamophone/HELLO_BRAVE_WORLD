extends StaticBody3D

@export var dynamic:bool 

@onready var trigger_zone = $Area3D
@onready var animation_player = $AnimationPlayer
@onready var sound = $AudioStreamPlayer3D

var open:bool = false
var player_detected:bool = false

func _ready():
	#if open:
		animation_player.seek(0.6)

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
		open = !open

func save():
	if dynamic:
		var save_dict = {
			"filename" : get_scene_file_path(),
			"parent" : get_parent().get_path(),
			"open" : open
		}
		return save_dict
