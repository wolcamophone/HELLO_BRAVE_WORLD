extends Node3D

@onready var music:AudioStreamPlayer = $AudioStreamPlayer
@onready var intro_cutscene: Control = $IntroCutscene

func _ready():
	# Cleanup entities and hide HUD so this level is just the 
	if HUD.visible:
		HUD.visible = false
	if GameMaster.active_player:
		GameMaster.active_player.queue_free()

	if GameMaster.skip_intro_cutscene:
		end_intro_cutscene()

func _unhandled_input(event: InputEvent) -> void:
	if intro_cutscene != null:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
			end_intro_cutscene()

func _on_intro_cutscene_finished() -> void:
	end_intro_cutscene()

func end_intro_cutscene():
	if intro_cutscene != null:
		intro_cutscene.queue_free()
	if !music.playing:
		music.play()
	# Toggle bool now so cutscene does not play again when returning to the main menu. -CD 
	GameMaster.skip_intro_cutscene = true
	
