extends AudioStreamPlayer3D

func _on_light_area_trigger_area_entered(area):
	if area.is_in_group("player"):
		play()
