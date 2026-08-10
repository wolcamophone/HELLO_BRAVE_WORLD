extends Area3D
class_name Collectible

@export var coin_value:int = 1
@export var red_coin:bool = false
@export var extra_life:bool = false
@export var rotation_speed:float = 1
@export var persistent:bool
var collected:bool = false

@onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var sparkle: GPUParticles3D = $Sparkle

func _ready() -> void:
	if collected:
		queue_free()
	self.area_entered.connect(_on_area_entered)
	mesh.rotation.y -= randf_range(0, TAU)
	sound.finished.connect(queue_free)

func _process(delta: float) -> void:
	mesh.rotation.y += wrapf(rotation_speed * delta, 0, TAU)

func _on_area_entered(area):
	if collected == true:
		return
	
	if area.is_in_group("player"):
		collected = true
		ScoreCounter.coins += coin_value
		mesh.visible = false
		sound.play()
		sparkle.emitting = true
	
	# Important: A name and value must be assigned to a collectible to match to the ScoreCounter.
	if red_coin:
		ScoreCounter.red_coins += 1
	
	if extra_life:
		ScoreCounter.lives +=1

func save_cfg():
	GameMaster.save_game_cfg.set_value("Coins", "%s collected" % [name], collected)
