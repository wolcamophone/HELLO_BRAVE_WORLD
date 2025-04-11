extends Node


### Teleport targets a specific entity and retrieves rotation/position data from said entity to apply to the player. -CD
#func teleport(tp_target):
	#if tp_target:
		#active_player.global_position = tp_target.global_position
		#active_player._rotation_root.rotation.y = tp_target.rotation.y # Rotate the rotation root as rotating the whole Player prefab itself bugs the player move direction relative to the camera's orientation.
		#active_player._spring_arm.rotation.y = tp_target.rotation.y
		#active_player._spring_arm.global_position = active_player._head.global_position # Avoid camera awkwardly zooping super fast back to player across level.
	#else:
		#printerr("Could not find tp target!")
		#return


### DEPREC: Warp takes in a Vector3 of coordinates for the input and places the player at those coordinates. -CD
#func warp(wp_position:Vector3, wp_rotation:int):
	#if wp_position && wp_rotation:
		#active_player.global_position = wp_position
		#active_player._rotation_root.rotation.y = wp_rotation # Rotate the rotation root as rotating the whole Player prefab itself bugs the player move direction relative to the camera's orientation.
		#active_player._spring_arm.rotation.y = wp_rotation
		#active_player._spring_arm.global_position = active_player._head.global_position # Avoid camera awkwardly zooping super fast back to player across level.
	#else:
		#printerr("Invalid warp coordinates given. Please provide a Vector3 for global position and ")
		#return
