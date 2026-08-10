extends CharacterBody3D
class_name NPC

@export_category("Character Info")
@export var npc_name:String = ""

@export_category("NPC Brain")
@export var target_last:Node3D = null
@export var targets_detected:Array = []
@export var random_wander_distance_min:float = 2.0
@export var random_wander_distance_max:float = 10.0
var location_current
var location_next
var detection_level:int = 0

@export_category("Physics Vars")
@export var speed = 5.0
@export var jump_velocity = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum states {Idle, Wander, Attention, Alert, Chase, Attack}
var state_current = states.Idle

@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
@onready var behavior_timer_idle:Timer = $BehaviorTimerIdle
@onready var area_detection: Area3D = $AreaDetectable
@onready var rotation_root: Node3D = $RotationRoot
@onready var sight_line: RayCast3D = $SightLine

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	sight_line.look_at(GameMaster.active_player._ears.global_position)
	
	detection()
	
	state_process()
	
	if nav_agent.debug_enabled == true:
		print("TestNPC: target_last = %s" % [target_last])

#region State Machine
func state_process():
	match state_current:
		states.Idle:
			pass
		
		states.Wander:
			pass
		
		states.Attention:
			pass
		
		states.Alert:
			if detection_level == 2:
				move_toward_target()
			elif detection_level < 2:
				state_switch(states.Attention)
			elif detection_level > 2:
				state_switch(states.Attention)
		
		states.Chase:
			if detection_level == 3:
				move_toward_target()
			elif detection_level < 3:
				state_switch(states.Attention)
		
		states.Attack:
			pass
	
func state_switch(to_state):
	state_current = to_state
	
	pass
#endregion

func detection():
	targets_detected = area_detection.get_overlapping_areas()
	for node in targets_detected:
		if node.is_in_group("player"):
			update_target(node)
			target_last = node
			print("TestNPC: I hear the player! - %s" % [target_last])
	
	sight_line.look_at(GameMaster.active_player._head.global_position)
	
	var spotted = sight_line.get_collider()
	if spotted == null:
		return
	if spotted.is_in_group("player"):
		print("TestNPC: I see the player! - %s" % [spotted])
	
	detection_level = spotted + target_last

func target_reached() -> void:
	update_target(global_position)
	target_last = null

func move_toward_target():
	#region Code to process getting the player position and moving the NPC toward them along the nav mesh.
	location_current = global_transform.origin
	location_next = nav_agent.get_next_path_position()
	var direction:Vector3 = (location_next - location_current).normalized() * speed ## Linear Math Calculation each frame that does the moving of this object toward its target.
	nav_agent.set_velocity(direction)
	if target_last: # this skips a nil throw when the target_last gets removed or set to null.
		rotation_root.look_at(target_last.global_position)
	#endregion

	#match state_current:
		#states.Idle:
			#target == null
		#
		#_:
			#states.Idle

func get_random_point(random_point:Vector3 = Vector3.ZERO) -> Vector3:
	random_point = Vector3(global_position.x+randi_range(random_wander_distance_min,random_wander_distance_max),global_position.y,global_position.z+randi_range(random_wander_distance_min,random_wander_distance_max))
	return random_point

func update_target(target_location):
	await get_tree().physics_frame
	if target_location is Vector3:
		nav_agent.set_target_position(target_location)
	if target_location is Node3D:
		nav_agent.set_target_position(target_location.global_position)
	

func update_avoidance(safe_velocity:Vector3):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()

func _on_behavior_timer_idle_timeout():
	pass # Replace with function body.
