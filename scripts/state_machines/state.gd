extends Node
class_name State

signal state_transition

func enter():
	print("Play an animation here, like a footslide to stop.")
	pass

func _process(delta: float) -> void:
	if Input.get_vector("move_lft","move_rgt","move_fwd","move_bwd"):
		pass
		#transition to move state

func exit():
	pass
