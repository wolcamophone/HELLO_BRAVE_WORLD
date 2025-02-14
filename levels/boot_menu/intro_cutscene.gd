extends Control

func _on_video_stream_player_finished() -> void:
	queue_free()
