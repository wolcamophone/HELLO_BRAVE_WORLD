class_name Checkpoint
extends Node3D

signal checkpoint_activated


@export var checkpoint_name:String = name
@export var status_report:String = "" # TODO: Dialogue message and info to show up when player selects the "Status Report" option in checkpoint menu.
@export var claimed: bool = false
@export var active: bool = false

#@onready var activation_zone:Area3D = $Area3D
@onready var mesh_vendingmachine:MeshInstance3D = $VendingMachine
@onready var screen_glow:OmniLight3D = $VendingMachine/ScreenGlow
@onready var pin_light:MeshInstance3D = $VendingMachine/PointLight
@onready var pin_light_blink_timer:Timer = $BlinkTimer
@onready var respawn_position:Marker3D = $Marker3D

var player_detected = false


func _ready():
	if !claimed:
		screen_glow.visible = false
		pin_light_blink_timer.start()
		mesh_vendingmachine.get_active_material(0).emission = "000000" #Black
	elif claimed:
		screen_glow.visible = true
		pin_light_blink_timer.stop()
		mesh_vendingmachine.get_active_material(0).emission = "00ff00" #Green
	
	if !active:
		pin_light.visible = false
	elif active:
		pin_light.visible = true

func register_checkpoint():
	# TODO: GameMaster should have an Array or Dictionary of all checkpoint entities found in current level.
	#GameMaster.checkpoints_available[checkpoint_name] += self
	return checkpoint_name


func _on_area_3d_area_entered(area):
	if area.is_in_group("player"):
		player_detected = true
		print("Player found checkpoint.")
func _on_area_3d_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false
		print("Player left checkpoint.")

func _input(event):
	#if GameMaster.checkpoint_current != self:
		#pin_light.visible = false
	#elif GameMaster.checkpoint_current == self:
		#pin_light.visible = true
	
	if player_detected && event.is_action_pressed("interact") && !active:
		active = true
		mesh_vendingmachine.get_active_material(0).emission = "00ff00" #Green
		screen_glow.visible = true
		pin_light.visible = true
		pin_light_blink_timer.stop()
		GameMaster.checkpoint_current = self
		GameMaster.checkpoint_current_name = checkpoint_name
		
		print("Checkpoint activated!")
		emit_signal("checkpoint_activated")

func _on_timer_timeout() -> void:
	pin_light_blink_timer.start()
	pin_light.visible = !pin_light.visible

func register():
	GameMaster.checkpoints_available[name] = self

#func save():
	#var save_dict = {
		#"filename" : get_scene_file_path(),
		#"parent" : get_parent().get_path(),
		#"claimed" : claimed,
		#"active" : active,
		#"level_name_current" : name,
		#"level_instance" : GameMaster.level_instance,
		#"level_previous" : GameMaster.level_previous,
		#"checkpoint_current" : GameMaster.checkpoint_current,
		#"checkpoint_previous" : GameMaster.checkpoint_previous,
	#}
	#return save_dict

func save_cfg():
	GameMaster.save_game_cfg.set_value("Checkpoint", "current_checkpoint", checkpoint_name)
