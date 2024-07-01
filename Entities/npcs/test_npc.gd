class_name NPC
extends CharacterBody3D

@export var npc_name:String = ""

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var behavior_timer_idle = $BehaviorTimerIdle

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = 0
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func get_random_point() -> Vector3:
	var random_point:Vector3 = Vector3.ZERO
	var ai_position:Vector3 = global_position
	random_point = Vector3(ai_position.x+randi_range(2,10),ai_position.y,ai_position.z+randi_range(2,10))
	return random_point


func _on_behavior_timer_idle_timeout():
	pass # Replace with function body.
