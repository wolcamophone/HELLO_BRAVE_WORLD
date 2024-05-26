extends CharacterBody3D
class_name Android

signal trigger_hurt(hurtme)
signal trigger_attack(damage)
signal health_changed(new_health)
signal dead()

@export_category("ANDROID 9001")
@export_group("Gameplay Values and Objects")
@export var MAX_HEALTH: int = 8
@export var _attack_type: PackedScene
enum States {idle,
			walking,
			attack,
			airborne,
			dead}
@export var current_state = States.idle

@export_group("Acceleration Values")
@export var MOVEMENT_STRENGTH: float = 1.0
@export var SPEED: float = 10
var RUN_SPEED: float = 10
var SPRINT_SPEED: float = 16
@export var AIR_SPEED: float = 8

@export_group("Physics Values")
@export var FRICTION: float = 0.5
@export var AIR_FRICTION: float = 0.9
@export var MAX_JUMP_VELOCITY: float = 12
@export var MIN_JUMP_VELOCITY: float = 6

@export var CUSTOM_GRAVITY: bool = false
@export var GRAVITY:float 
@export_enum("Down:1", "Zero-G:0", "Up:-1") var GRAVITY_STATE = 1

#@export var GRAVITY: int = 20
#	Get the gravity from the project settings to be synced with RigidBody nodes.
#var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")


#	Variables
var direction = Vector3.ZERO
var FOLLOW_TWEEN: Tween
const LERP_VAL:float = 0.2

#	ON READY VARS
@onready var HEALTH:int = MAX_HEALTH

#@onready var _state_machine = $StateMachine
@onready var _spring_arm: SpringArm3D = $Marker3D/SpringArm3D
@onready var _head: Marker3D = $Marker3D
@onready var _ears: AudioListener3D = $Marker3D/AudioListener3D
@onready var _rotation_root: Node3D = $RotationRoot
@onready var _anim_player: AnimationTree = $RotationRoot/PlayerModel/AnimationTree
@onready var _iFrames_timer: Timer = $iFrames
#@onready var _wall_slide_cooldown: Timer = $WallSlideCooldown
@onready var _LedgeGrabberY: RayCast3D = $RotationRoot/LedgeGrabberY
@onready var _LedgeGrabberZ: RayCast3D = $RotationRoot/LedgeGrabberZ
@onready var _HeadBumper: Area3D = $RotationRoot/HeadBumper
@onready var _LandingShadow: Decal = $LandingShadow
#@onready var _last_strong_direction = Vector3.FORWARD

func _ready():
	HUD.visible = true
	#GameMaster.MainMenu
	HEALTH = 8
	set_as_top_level(true)


func _physics_process(delta):
	_apply_gravity(delta)
	_apply_movement()
	_apply_animation()

func _apply_gravity(delta):
	if !CUSTOM_GRAVITY:
		GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")
	if not is_on_floor():
		velocity.y -= GRAVITY * GRAVITY_STATE * delta
	

func _apply_movement():
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = MAX_JUMP_VELOCITY
	if is_on_wall_only() and Input.is_action_just_pressed("jump") and velocity.y < -1:
		velocity = get_wall_normal() * MIN_JUMP_VELOCITY
		velocity.y = MAX_JUMP_VELOCITY

	var input_dir = Input.get_vector("move_lft", "move_rgt", "move_fwd", "move_bwd")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
		
	
	if direction:
		_rotation_root.rotation.y = lerp_angle(_rotation_root.rotation.y, atan2(-velocity.x, -velocity.z), 
		LERP_VAL)
	# This determines how the player moves if on/off the floor plus moving or not
	if direction && is_on_floor():
		velocity.x = lerpf(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerpf(velocity.z, direction.z * SPEED, LERP_VAL)
	elif !direction && !is_on_floor():
		velocity.x = lerpf(velocity.x, velocity.x * AIR_FRICTION, LERP_VAL)
		velocity.z = lerpf(velocity.z, velocity.z * AIR_FRICTION, LERP_VAL)
	elif direction && !is_on_floor():
		velocity.x = lerpf(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerpf(velocity.z, direction.z * SPEED, LERP_VAL)
		#print(velocity)
	else:
		velocity.x = lerpf(velocity.x, 0.0, FRICTION)
		velocity.z = lerpf(velocity.z, 0.0, FRICTION)
	

	if Input.is_action_pressed("sprint"):
		SPEED = SPRINT_SPEED
		#floor_max_angle = 30
		#floor_snap_length = 0.3
		#floor_block_on_wall = false
	elif !Input.is_action_pressed("sprint"):
		SPEED = RUN_SPEED
		#floor_max_angle = 46
		#floor_snap_length = 0.2
		#floor_block_on_wall = true
	move_and_slide()

func _apply_animation():
	_anim_player.set("parameters/IdleWalkRun/blend_position", velocity.length() / SPEED*2)
	_anim_player.set("parameters/BlendAir/blend_amount", !is_on_floor())
	_anim_player.set("parameters/Jump/request", is_on_floor())

func _input(event):
	# Handle jumping (Part 2), sets the velocity to a weaker value mid jump to
	# simulate holding jump button to jump higher. This has a cool little exploit
	# where the player can time holding the jump button long enough to release
	# and jump slightly higher!
	if event.is_action_released("jump") and velocity.y > MIN_JUMP_VELOCITY:
		velocity.y = MIN_JUMP_VELOCITY
	



func _process(delta):
	tweener()
	_ears.rotation = _spring_arm.rotation
	if global_transform.origin.y < -200.0: #Respawns the player if falling below this boundary.
		global_transform.origin = Vector3(0,3,0)

	if Input.is_action_just_pressed("attack1"):
		var b = _attack_type.instantiate()
		b.rotation_degrees = _rotation_root.global_transform.basis.get_euler()
		_rotation_root.add_child(b)

func tweener():
	if GameMaster.ViewBob:
		if FOLLOW_TWEEN:
			FOLLOW_TWEEN.kill()
		FOLLOW_TWEEN = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
		FOLLOW_TWEEN.tween_property(_spring_arm, "position", _head.global_position,0.3)
		FOLLOW_TWEEN.tween_property(_spring_arm, "position:y", _head.global_position.y,0.6)
	elif !GameMaster.ViewBob:
		_spring_arm.global_position = _head.global_position

func damage(amount):
	if _iFrames_timer.is_stopped():
		_iFrames_timer.start()
		_set_health(HEALTH - amount)

func kill():
	queue_free()

func _set_health(value):
	var prev_health = HEALTH
	HEALTH = clamp(value, 0, MAX_HEALTH)
	if HEALTH != prev_health:
		emit_signal("health_changed", HEALTH)
		if HEALTH == 0:
			kill()
			emit_signal("dead")

func _hit_box(area):
#	if ![area.is_in_group("attack_player")].has(area):
#		print("Player collided!")
	if area.is_in_group("trigger_hurt"):
		damage(1)
		HUD.display_health = HEALTH
		print("Damage taken! ", HEALTH)
	if area.is_in_group("enemy"):
		damage(1)
		HUD.display_health = HEALTH
		print("Damage taken! ", HEALTH)



func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"pos_z" : position.z,
		"current_health" : HEALTH,
	}
	return save_dict