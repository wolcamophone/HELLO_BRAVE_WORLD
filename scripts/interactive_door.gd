extends StaticBody3D
class_name InteractiveDoor ## Entity that allows for creating a door object with closed/opened state, as well as potential for transfering and loading the player into another level.

signal prompt_for_lock_entity ## Connect this signal to a lock entity so that it may call the lock query func and return a firing signal to open the door and set door_state to 0 or "unlocked", or the door will remain locked.

@export_enum("unlocked", "locked", "broken") var door_state = 0
@export var open:bool = false
@export var overwrite_prompt_text:String = "Open Door" ## Text to display on HUD when the player approaches close enough to interact with the door.
@export var dynamic_to_save:bool = false ## Door will stay opened between saving/loading the game.
@export var warp_door:bool = false ## If false, door opens and closes as if it were a regular interactive prop. If true, door will load and transfer player to level name specified under transfer_to_level property.
@export var transfer_to_level:String ## Name of folder and packed scene file to be loaded for the next level.
@export var transfer_to_position:Vector4 ## XYZ coordinates followed by rotation.
#@export var model:MeshInstance3D

#@onready var door_model = 
@onready var trigger_zone:AreaInteraction = $InteractionArea
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sfx_open:AudioStreamPlayer3D = $SFXOpen
@onready var sfx_locked: AudioStreamPlayer3D = $SFXLocked
@onready var sfx_broken: AudioStreamPlayer3D = $SFXBroken
@onready var timer:Timer = $Timer


var player_detected:bool = false

func _ready():
	if open && door_state != 2:
		animation_player.seek(0.6)
	if door_state == 0:  ## "unlocked"
		update_prompt()
	elif door_state == 1:  ## "locked"
		trigger_zone.prompt_text = "Door Locked"
	elif door_state == 2:  ## "broken"
		trigger_zone.prompt_text = "Door Broken"

func _on_area_3d_area_entered(area):
	if area.is_in_group("player"):
		player_detected = true
func _on_interaction_area_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false

func _input(event):
	if player_detected && event.is_action_pressed("interact"):
		if door_state == 0: ## "unlocked"
			sfx_open.play()
			if !open:
				animation_player.play("Open")
			elif open:
				animation_player.play_backwards("Open")
			if !warp_door:
				open = !open
			elif warp_door:
				GameMaster.load_level(transfer_to_level,1)
				GameMaster.level_transfer_destination = transfer_to_position
		
		if door_state == 1: ## "locked"
			emit_signal("prompt_for_lock_entity") 
			sfx_locked.play()
			
		if door_state == 2: ## "broken"
			sfx_broken.play()

func unlock_door():
	door_state = 0
	update_prompt()

func update_prompt():
	if overwrite_prompt_text != null:
		trigger_zone.prompt_text = overwrite_prompt_text
	elif overwrite_prompt_text == null && !warp_door:
		trigger_zone.prompt_text = "Open Door"
	elif overwrite_prompt_text == null && warp_door:
		trigger_zone.prompt_text = "Travel to %s" % transfer_to_level
	trigger_zone.display_prompt()

func save_cfg():
	if dynamic_to_save:
		GameMaster.save_game_cfg.set_value("Doors", "%s door_state" % [name], door_state)
		GameMaster.save_game_cfg.set_value("Doors", "%s open" % [name], open)
