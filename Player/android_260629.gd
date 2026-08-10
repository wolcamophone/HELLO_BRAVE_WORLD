extends CharacterBody3D
class_name Android

signal trigger_hurt(hurtme)
signal trigger_attack(damage)
signal health_changed(new_health)
signal died()

@export_category("ANDROID 72")
@export_group("Gameplay Values and Objects")
@export var health_max: int = 8
var health_current:int = 8:
	set(value):
		health_current = clamp(value, 0, health_max)
		health_changed.emit(health_current)
	#get:
		#return godmode
@export var _attack_type: PackedScene
@export var gibs_effect: PackedScene ## Particle or Entity prefab to spawn on the player upon dying. Could be an explosion, confetti, or another NPC.
enum states {idle,
			crouched,
			sneaking,
			walking,
			sprinting,
			attack,
			jumping,
			airborne,
			dead} 
@export var current_state = states.idle ## State that player is in to control flow of contextual action and conditions.
@export var view_bob:bool = true ## When true, the camera smoothly floats to follow the player. When false, the camera stays fixed to the position of the player.
@export var crouch_toggle:bool = true
@export var jump_buffer:bool = true

@export_group("Movement Acceleration Values")
@export var movement_strength: float = 1.0 ## General value that weighs into most movement scale calculations. 
var speed: float = 10 ## Current value for player's movement speed.
@export var run_speed: float = 10 ## How fast the player moves by default.
@export var sprint_speed: float = 16 ## How fast the player moves when holding sprint.
@export var sneak_speed_coef: float = 0.4 ## Weight to multiply movement speed by while crouched.
@export var air_speed_coef: float = 0.05 ## Weight to multiply movement speed by while in air.
@export var enable_stair_stepper:bool = false ## Adds a small upward momentum to the player so they don't get stuck on a 2 pixel high twig or piece of ramp geometry.

@export_group("Jump Values")
@export var max_jump_force: float = 12 ## Greatest force to be applied to jump. Applies upon pressing and holding jump button.
@export var min_jump_force: float = 6 ## Least force to be applied to jump. Applies upon releasing jump button.
@export var wall_jump_force: float = min_jump_force
@export var max_jump_count:int = 1 ## Reset value for max double jumps player can perform once of.
@export var wall_jump_vel_tollerance: int = 2 ## Player's y velocity must be less than this value to be able to perform a wall jump.

@export_group("Physics Values")
var face_to_rotation:int ## Rotation in degrees for the player to turn to upon spawning in.
var air_jump_count:int = 1 ## Number of jumps player has to expend in air.
var wall_jump_count:int = 1 ## Number of jumps player has to expend off of walls.
@export var friction: float = 0.5 ## Weight of influence player has over movement control while on ground.
@export var air_friction: float = 0.9 ## Weight of influence player has over movement control while in air.
@export var use_custom_gravity: bool = true ## If true, uses var gravity for value of force. If false, fetches the project setting's default value for gravity.
@export var gravity:float = 20
@export_enum("Down:1", "Zero-G:0", "Up:-1") var gravity_direction = 1



#	STAND ALONE VARIABLES
var direction = Vector3.ZERO
var FOLLOW_TWEEN: Tween
const LERP_VAL:float = 0.2

# ON READY VARS
# Colliders
@onready var _collision: CollisionShape3D = $CollisionShape3D
@onready var _collision_crouch: CollisionShape3D = $CollisionShapeCrouch
@onready var _spring_arm: SpringArm3D = $CameraHead/SpringArm3D
#@onready var _spring_arm: SpringArm3D = $SpringCamHead/SpringArm3D
@onready var _head: Marker3D = $CameraHead
@onready var _spring_head: SpringArm3D = $SpringCamHead
#@onready var _wall_slide_cooldown: Timer = $WallSlideCooldown
#@onready var _LedgeGrabberY: RayCast3D = $RotationRoot/LedgeGrabberY
#@onready var _LedgeGrabberZ: RayCast3D = $RotationRoot/LedgeGrabberZ
@onready var _stair_stepper: RayCast3D = $RotationRoot/StairStepper
@onready var _stair_movable: Area3D = $RotationRoot/StairMovable

# Mesh Handlers
@onready var _rotation_root: Node3D = $RotationRoot
@onready var _player_model = $RotationRoot/PlayerModel
@onready var _player_mesh: MeshInstance3D = $RotationRoot/PlayerModel/metarig_Android/Skeleton3D/Android
@onready var _anim_tree: AnimationTree = $RotationRoot/PlayerModel/AnimationTree
#@onready var _anim_player: AnimationPlayer = $RotationRoot/PlayerModel/AnimationPlayer

# Other Nodes
@onready var _ears: AudioListener3D = $CameraHead/AudioListener3D
#@onready var _ears: AudioListener3D = $SpringCamHead/AudioListener3D
@onready var _iFrames_timer: Timer = $iFrames
@onready var jump_buffer_timer: Timer = $JumpBuffer

@onready var _sfx_jump:AudioStreamPlayer3D = $Jump
@onready var _sfx_footstep: AudioStreamPlayer3D = $Footstep
@onready var _sfx_death_twitch: AudioStreamPlayer3D = $DeathTwitch
@onready var _wall_slide_particles: GPUParticles3D = $WallSlideParticles
@onready var omni_light_3d_tattoo: OmniLight3D = $OmniLight3DTattoo
@onready var _death_timer: Timer = $DeathTimer



func _ready():
	set_as_top_level(true)
	
	_death_timer.timeout.connect(GameMaster.respawn_player)
	
	_spring_arm.add_excluded_object(self)
	_stair_stepper.add_exception(self)
	#_spring_arm.add_excluded_object(_collision)
	#_spring_head.add_excluded_object(self)
	#_spring_head.add_excluded_object(_collision)
	
	if !use_custom_gravity:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	HUD.visible = true
	#GameMaster.MainMenu
	health_current = 8
	_switch_state(states.idle)


#region Constant Process
func _process(delta):
	pass

func _physics_process(delta):
	#_state_machine()
	_apply_gravity(delta)
	if current_state != states.dead:
		_apply_jumping()
		_apply_movement()
		_apply_attacking()
		_apply_misc_actions()
	
	move_and_slide()
	
	_apply_animation()
	_camera_follow()
	
	if position.y < -50000: # Respawns the player at world origin if falling below this boundary.
		position = Vector3(0,3,0)
	
	_ears.rotation = _spring_arm.rotation
	_rotation_root.rotation_degrees.y = wrapf(_rotation_root.rotation_degrees.y, 0, 360) # Prevent player from accumulating needlessly high rotation values.

func _apply_attacking():
	if Input.is_action_just_pressed("attack1") && current_state != states.dead: # TODO: This should go under the attacking state once the state_machine() match is set up.
		var b = _attack_type.instantiate()
		b.rotation_degrees = _rotation_root.global_transform.basis.get_euler()
		_rotation_root.add_child(b)
		current_state = states.attack

func _state_machine(): ## Runs constantly under _physics_process(delta). See _switch_state() for calling impulses such as one-shot animations.
	# TODO: set up states to contain functionality for movement calculations instead of processing them under the if statements. 
	match current_state: # Under each state is the code that runs constantly, then the conditionals that determine which other states are viable to switch to.
		states.idle:
			velocity.x = lerpf(velocity.x, 0.0, friction)
			velocity.z = lerpf(velocity.z, 0.0, friction)
			
		states.crouched:
			speed *= sneak_speed_coef
			_apply_movement()
		
		states.walking:
			speed = run_speed
			_apply_movement()
			
		states.sprinting:
			speed = sprint_speed
			_apply_movement()
		
		states.airborne:
			_apply_movement()
			
			if is_on_floor():
				_switch_state(states.idle)
			
		states.dead:
			velocity.x = lerpf(velocity.x, 0.0, friction)
			velocity.z = lerpf(velocity.z, 0.0, friction)
		
		#_: # if nothing else...
			#pass
		#var state_machine_result:
			#print(state_machine_result)
			#pass
		
		#states.new_state_example:
			##   set physics parameters
			#speed = 
			##   This func takes in player's input and moves the character.
			#_apply_movement() 
			##   These set player's velocity manually.
			#velocity.x = 
			#velocity.z =
			##   Conditionals to switch into other state.
			#if Input.is_action_just_pressed("jump"):
				#pass

func _switch_state(to_state): ## Called once instead of continuously, used for one-shot ainimations or throwing attacks
	current_state = to_state
	
	match current_state:
		states.idle:
			pass
		
		states.crouched:
			pass
		
		states.walking:
			pass
			
		states.sprinting:
			pass
		
		states.airborne:
			pass
		
		states.dead:
			_sfx_death_twitch.play()
#endregion



#region Physics/Movement Handling
func _apply_gravity(delta):
	if !is_on_floor():
		velocity -= (gravity * up_direction) * delta


func _apply_jumping():
	if is_on_floor(): # Normal jump from floor
		if Input.is_action_just_pressed("jump"): #TODO: Work in a proper callback for jump_buffer.
			velocity += max_jump_force * up_direction
			_sfx_jump.play()
	
	if is_on_floor_only(): # Resets Jump Counters
		air_jump_count = max_jump_count
		wall_jump_count = max_jump_count 
	
	if !is_on_floor() and !is_on_wall()  && air_jump_count > 0: # Double jumping with variable counter
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer.start()
			velocity.y = max_jump_force
			air_jump_count -= 1
			_sfx_jump.play()
	clampi(air_jump_count, 0, max_jump_count)
	
	if is_on_wall_only() and velocity.y < wall_jump_vel_tollerance && wall_jump_count > 0: # Wall Jumping
		_wall_slide_particles.emitting = true
		if Input.is_action_just_pressed("jump"):
			velocity = get_wall_normal() * wall_jump_force
			velocity.y = max_jump_force
			wall_jump_count -= 1
			_sfx_jump.play()
	else:
		_wall_slide_particles.emitting = false
	

func _input(event):
	if event.is_action_released("jump") and velocity.y > min_jump_force: # Gives the player a weaker jump when releasing the jump button early.
		velocity.y = min_jump_force


func _apply_movement():
	var input_dir = Input.get_vector("move_lft", "move_rgt", "move_fwd", "move_bwd")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, _spring_arm.rotation.y).normalized()
	
	
	
# For logic flow reasons, the crouch has to be called before direction calc and sprint called after direction calc for the changes in speed to apply.
	if Input.is_action_pressed("sneak"): 
		speed *= sneak_speed_coef
		_switch_state(states.crouched)
	
	
	# This determines the appropriate methods for player model's rotation
	if direction && velocity && is_on_floor(): ## Player rotates in direction of input movement.
		_rotation_root.rotation.y = lerp_angle(_rotation_root.rotation.y, atan2(-direction.x, -direction.z), 
		LERP_VAL)
	elif direction && velocity && !is_on_floor(): ## Player rotates toward their headed velocity.
		_rotation_root.rotation.y = lerp_angle(_rotation_root.rotation.y, atan2(-velocity.x, -velocity.z), 
		LERP_VAL)
		current_state = states.airborne

	# This determines how the player moves if on/off the floor, plus moving or not
	if direction && is_on_floor(): # Move attempt, and is on floor.
		velocity.x = lerpf(velocity.x, direction.x * (speed * movement_strength), LERP_VAL)
		velocity.z = lerpf(velocity.z, direction.z * (speed * movement_strength), LERP_VAL)
		#_stair_check()
		current_state = states.walking
	elif !direction && !is_on_floor(): # NO Move attempt, and is NOT on floor.
		velocity.x = lerpf(velocity.x, velocity.x * (air_friction * movement_strength), LERP_VAL)
		velocity.z = lerpf(velocity.z, velocity.z * (air_friction * movement_strength), LERP_VAL)
		current_state = states.airborne
	elif direction && !is_on_floor(): # Move attempt, and is NOT on floor.
		velocity.x = lerpf(velocity.x, (direction.x * (speed * movement_strength)), air_speed_coef)
		velocity.z = lerpf(velocity.z, (direction.z * (speed * movement_strength)), air_speed_coef)
		current_state = states.airborne
	else:
		velocity.x = lerpf(velocity.x, 0.0, friction)
		velocity.z = lerpf(velocity.z, 0.0, friction)
		current_state = states.idle



	if !Input.is_action_pressed("sprint"):
		speed = run_speed * movement_strength
		_switch_state(states.walking)
	elif Input.is_action_pressed("sprint"):
		speed = sprint_speed * movement_strength
		_switch_state(states.sprinting)



func _stair_check() -> void: # Extends from _apply_movement(). Adds a small upward momentum to the player so they don't get stuck on a 2 pixel high twig or piece of ramp geometry.
	var going_up:bool = false
	if enable_stair_stepper == false:
		return
	elif enable_stair_stepper == true:
		if _stair_stepper.collide_with_bodies && is_on_wall():
			going_up = true
		for f in _stair_movable.get_overlapping_bodies(): # Area3D has no .add_excluded_object(self) so I have to set up the nasty for loop that runs at delta. 
			if f != self:
				going_up = false
	
		if going_up: # this bool-flow condition is probably not the most optimal but works for now.
			global_position.y += 0.5
	#test_move()

func _apply_misc_actions():
	if Input.is_action_just_pressed("killbind"):
		kill()
#endregion



#region Animation Handling
func _apply_animation():
	# NOTE FOR AUDIO: In order for any AudioStreamPlayer3D to play their sound by trigger keyframes within animation playback, 
	# The AnimationTree node should have property Callback Mode/Discrete set to "Dominant" instead of default "Force Continuous",
	# The AudioStreamPlayer3D node should have property Playback Type set to "Stream",
	# 
	_anim_tree.set("parameters/IdleWalkRun/blend_position", velocity.length() / speed*2) # Blends velocity value into Idle-Walking-Running animations.
	_anim_tree.set("parameters/BlendAir/blend_amount", !is_on_floor()) # Blends in Airborne animation if the player is not touching the ground.
	_anim_tree.set("parameters/JumpShot/request", is_on_floor()) # Triggers the Jump one-shot animation.
	_anim_tree.set("parameters/BlendCrouch/blend_amount", current_state == states.crouched) # Toggles crouching animation with the crouching state.
	_anim_tree.set("parameters/CrouchCrawl/blend_position", velocity.length() / speed*2) # Blends velocity value into crawling animations.
	_anim_tree.set("parameters/BlendDeath/blend_amount", current_state == states.dead) # Blends twitchy death animation over all others if the death state is tripped.


	
	

func _camera_follow():
	if view_bob:
		if FOLLOW_TWEEN:
			FOLLOW_TWEEN.kill()
		FOLLOW_TWEEN = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
		FOLLOW_TWEEN.tween_property(_spring_arm, "position:x", _head.global_position.x,0.5)
		FOLLOW_TWEEN.tween_property(_spring_arm, "position:z", _head.global_position.z,0.5)
		FOLLOW_TWEEN.tween_property(_spring_arm, "position:y", _head.global_position.y,0.6)
	elif !view_bob:
		_spring_arm.global_position = _head.global_position
	#if GameMaster.teleport():
		#_spring_arm.global_position = _head.global_position
#endregion



#region Game Values
func damage(hurtme):
	if _iFrames_timer.is_stopped():
		_iFrames_timer.start()
		_set_health(hurtme)

func _set_health(value):
	var prev_health = health_current
	health_current -= clamp(value, 0, health_max)
	if health_current != prev_health:
		emit_signal("health_changed", health_current)
		if health_current == 0:
			kill()

func kill():
	_switch_state(states.dead)
	if gibs_effect:
		var ds = gibs_effect.instantiate()
		ds.position.y += 1.8
		add_child(ds)
	
	_death_timer.start(5)
	emit_signal("died")
	print("Android has been destroyed!")

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"player_pos_x" : snapped(position.x, 0.001), # Vector2 and 3 are not supported by JSON
		"player_pos_y" : snapped(position.y, 0.001),
		"player_pos_z" : snapped(position.z, 0.001),
		"health_current" : health_current,
	}
	return save_dict

func save_cfg():
	GameMaster.save_game_cfg.set_value("Android", "health_current", health_current)
	GameMaster.save_game_cfg.set_value("Android", "position", position)
	GameMaster.save_game_cfg.set_value("Android", "position_x", position.x)
	GameMaster.save_game_cfg.set_value("Android", "position_y", position.y)
	GameMaster.save_game_cfg.set_value("Android", "position_z", position.z)
	GameMaster.save_game_cfg.set_value("Android", "rotation", _rotation_root.rotation_degrees.y)
#endregion
