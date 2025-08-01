extends Node3D
class_name Checkpoint

signal checkpoint_found
signal checkpoint_left
signal checkpoint_claimed
signal checkpoint_activated

@export var status_report:String = "" ##: Dialogue message and info to show up when player selects the "Status Report" option in checkpoint menu.
@export var claimed: bool = false
@export var active: bool = false

@export_enum("new","claimed","active","broken") var checkpoint_state = 0 ## TODO: Script may be optimized at some point with a basic state check function instead of individual var flags.

#@onready var activation_zone:Area3D = $Area3D
@onready var mesh_vendingmachine:MeshInstance3D = $VendingMachine
@onready var screen_glow:OmniLight3D = $VendingMachine/ScreenGlow
@onready var pin_light:MeshInstance3D = $VendingMachine/PointLight
@onready var pin_light_blink_timer:Timer = $BlinkTimer
@onready var respawn_position:Marker3D = $Marker3D

var player_detected = false


func _ready():
	change_mesh()


#region Handling Interaction
func _on_area_3d_area_entered(area):
	if area.is_in_group("player"):
		player_detected = true
		CheckpointMenu.label_checkpoint_name.text = "Chk: %s" % name
		
		emit_signal("checkpoint_found")
		print("Player found checkpoint: %s" % name)

func _on_area_3d_area_exited(area):
	if area.is_in_group("player"):
		player_detected = false
		CheckpointMenu._close_menu() # We don't want the player interacting with the menu while they're long gone from the checkpoints interactive range.
		
		emit_signal("checkpoint_left")
		print("Player left checkpoint.")


func _input(event): ## Many and all checkpoints in a level can be claimed, but only one should be active and current.
	if player_detected && event.is_action_pressed("interact"):
		if !claimed:
			claimed = true
			
			emit_signal("checkpoint_claimed")
			print("Player claimed checkpoint: %s" % name) 
			
		if !active:
			active = true
			update_checkpoints()
			
			# Update meshes of both to meet conditionals for claimed/activity.
			change_mesh()
			if GameMaster.checkpoint_current != null:
				GameMaster.checkpoint_previous.change_mesh()
			
			emit_signal("checkpoint_activated")
			print("Checkpoint activated: %s" % GameMaster.checkpoint_current_name)
			print("Checkpoint previous: %s" % GameMaster.checkpoint_previous_name)
		
		CheckpointMenu.status_report = status_report
		CheckpointMenu._show_menu()
#endregion


#region Handling Checkpoint Lists
func update_checkpoints(): 
	if GameMaster.checkpoint_current == null:
		GameMaster.checkpoint_current = self
	
	if GameMaster.checkpoint_previous != GameMaster.checkpoint_current:
		# Make sure the same checkpoint can't occupy both current and previous slots upon multiple interactions.
		# Current checkpoint overrides previous.
		GameMaster.checkpoint_previous = GameMaster.checkpoint_current
		GameMaster.checkpoint_previous_name = GameMaster.checkpoint_current_name
		# This checkpoint is now the current one.
		GameMaster.checkpoint_current = self
		GameMaster.checkpoint_current_name = name
		# Deactivate previous checkpoint
		GameMaster.checkpoint_previous.active = false

func register(): ## This func is called from class WorldSpaceInfo
	GameMaster.checkpoints_available.append(self)
#endregion


#region Altering Appearance of Mesh
func _on_timer_timeout() -> void: ## Animation to toggle blinking pinlight.
	if !claimed:
		pin_light.visible = !pin_light.visible

func change_mesh(): ## Refresh the appearance of Checkpoint to reflect it's current state. 
	if !claimed:
		# Screen should be off and pinlight should only ever blink to indicate a newly discovered and unclaimed checkpoint.
		mesh_vendingmachine.get_active_material(0).emission = "000000" # Black
		screen_glow.visible = false
		pin_light.visible = true
		pin_light_blink_timer.start() 
	elif claimed:
		# Screen on indicates a claimed checkpoint.
		mesh_vendingmachine.get_active_material(0).emission = "00ff00" # Green
		screen_glow.visible = true
		pin_light_blink_timer.stop()
	
	# Solid pin light on/off indicates active/inactive respectively.
	# TODO: bug occurs where pinlight disappears upon claiming a checkpoint where claiming a checkpoint should also make it active. Apparently this func is being called twice in a row because print(active) below returns same result (2) false or (2) true
	if !active:
		print(active)
		pin_light.visible = false
	elif active:
		print(active) 
		pin_light.visible = true
#endregion


func save_cfg():
	GameMaster.save_game_cfg.set_value("Checkpoint", "current_checkpoint", GameMaster.checkpoint_current.name)
	GameMaster.save_game_cfg.set_value("Checkpoint", "previous_checkpoint", GameMaster.checkpoint_previous.name)
