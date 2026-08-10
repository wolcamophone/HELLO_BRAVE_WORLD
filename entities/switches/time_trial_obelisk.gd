extends Node3D

signal race_has_begun
signal race_has_ended

@export_enum("Start", "Finish", "Checkpoint") var type_of_race_marker = "Start"
@export var time_to_add:float = 10

@onready var mesh_instance_3d_2: MeshInstance3D = $MeshInstance3D2


func _ready() -> void:
	if type_of_race_marker != "Finish":
		mesh_instance_3d_2.visible = false

func prompt_race() -> void: ## This function should be called from a signal from an interactable button.
	if type_of_race_marker == "Start":
		begin_race()
	elif type_of_race_marker == "Finish":
		end_race()
	elif type_of_race_marker == "Checkpoint":
		checkpoint_reached()

func begin_race():
	MinigameTimeTrial.begin_time_trial(time_to_add)
	emit_signal("race_has_begun")

func checkpoint_reached():
	if MinigameTimeTrial.timer.time_left > 0:
		MinigameTimeTrial.timer.wait_time += time_to_add
		visible = false
		set_process(false)
		set_physics_process(false)

func end_race() -> void:
	if MinigameTimeTrial.timer.time_left > 0:
		MinigameTimeTrial.end_time_trial(true)
		emit_signal("race_has_ended")
	else:
		MinigameTimeTrial.end_time_trial(false)
	
	visible = true
	set_process(true)
	set_physics_process(true)
