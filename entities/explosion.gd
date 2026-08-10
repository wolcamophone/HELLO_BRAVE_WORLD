extends Node3D

@export var force:float = 12
@export var damage:float = 12

@onready var sparks:GPUParticles3D = $sparks
@onready var fireball:GPUParticles3D = $fireball
@onready var smoke:GPUParticles3D = $smoke
@onready var hurtbox:Area3D = $hurtbox
var hurtbox_timer:int = 0

func _ready() -> void:
	sparks.emitting = true
	fireball.emitting = true
	smoke.emitting = true
	hurtbox.damage = damage

func _process(delta: float) -> void:
	hurtbox_timer += 1
	if hurtbox_timer > 20:
		hurtbox

func _on_audio_stream_player_3d_finished() -> void:
	queue_free()

func _on_hurtbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		#area.HEALTH -= damage
		pass
