class_name Checkpoint
extends Node3D

signal checkpoint_activated


@export var checkpoint_name:String = ""
@export var status_report:String = ""
@export var claimed: bool = false
@export var active: bool = false
#@onready var activation_zone:Area3D = $Area3D
@onready var screen_glow:OmniLight3D = $VendingMachine/ScreenGlow
#@onready var _screen_emission = $VendingMachine
@onready var pin_light:MeshInstance3D = $VendingMachine/PointLight
#@onready var hud_prompt:GPUParticles3D = $HUDparticle
@onready var respawn_position:Marker3D = $Marker3D

var player_detected = false



func _ready():
	#GameMaster.register_checkpoint(self)
	#respawn_player()
	if GameMaster.checkpoint_current != self:
		pin_light.visible = false
	elif GameMaster.checkpoint_current == self:
		pin_light.visible = true
	if !claimed:
		screen_glow.visible = false
		#_screen_emission.surface_material_override.emission_enabled = false
	elif claimed:
		screen_glow.visible = true
	register_checkpoint()


func register_checkpoint():
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
	if GameMaster.checkpoint_current != self:
		pin_light.visible = false
	elif GameMaster.checkpoint_current == self:
		pin_light.visible = true
	if player_detected && event.is_action_pressed("interact") && !active:
		active = true
		GameMaster.checkpoint_current = self
		GameMaster.checkpoint_current_name = checkpoint_name
		screen_glow.visible = true
		print("Checkpoint activated!")
		emit_signal("checkpoint_activated")





func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"claimed" : claimed,
		"active" : active,
		"level_name_current" : name,
		"level_instance" : GameMaster.level_instance,
		"level_previous" : GameMaster.level_previous,
		"checkpoint_current" : GameMaster.checkpoint_current,
		"checkpoint_previous" : GameMaster.checkpoint_previous,
	}
	return save_dict
