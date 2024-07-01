extends Control

@onready var ResButton = $Video/HBox/VBox/HBox/ResButton
@onready var fullscreen = $Video/HBox/VBox/Fullscreen

var Resolutions: Dictionary = {
	"800x600": Vector2i(800,600),
	"1024x600":Vector2i(1024,600),
	"1280x720":Vector2i(1280,720),
	"1440x900":Vector2i(1440,900),
	"1600x900":Vector2i(1600,900),
	"1920x1080":Vector2i(1920,1080),
	"2560x1440":Vector2i(2560,1440),
	"3840x2160":Vector2i(3840,2160)
}

var view_bob

# Check this against save func later to see if .json supports Vector2
var display_current_resolution:Vector2i

var audio_vol_master:int = 0
var audio_vol_music:int = -12
var audio_vol_sfx:int = 0
var audio_vol_ambience:int = 0
var audio_vol_voice:int = 0
var audio_vol_radio:int = 0
var audio_vol_ui:int = 0


### Gameplay Settings. ###
func _on_view_bob_toggled(toggled_on):
	GameMaster.ViewBob = toggled_on
	view_bob = GameMaster.ViewBob



### Video Settings. ###
func _ready():
	AddResolutions()

func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func AddResolutions():
	for r in Resolutions:
		ResButton.add_item(r)

func _on_ResButton_item_selected(index): 
	# Gets Vector 2 from dropdown menu then resizes window.
	var size = ResButton.get_item_text(index)
	get_window().set_size(Resolutions[size])
	display_current_resolution = Resolutions[size]

func _on_VSync_toggled(button_pressed):
	DisplayServer.window_set_vsync_mode(button_pressed)

func _on_AntiAlias_item_selected(index):
	get_viewport().set_msaa(index)
	if index == 5:
		get_viewport().set_use_fxaa(true)
		get_viewport().set_msaa(0)
	else:
		get_viewport().set_use_fxaa(false)

func _on_LargeCursor_toggled(button_pressed):
	if button_pressed:
		var CursorL = load("res://Graphics/UI/CursorL.png")
		Input.set_custom_mouse_cursor(CursorL)
	elif not button_pressed:
		var CursorM = load("res://Graphics/UI/CursorM.png")
		Input.set_custom_mouse_cursor(CursorM)




### Audio Settings. ###
func _on_vol_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	if value > -48:
		AudioServer.set_bus_mute(0, false)
	elif value <= -48:
		AudioServer.set_bus_mute(0, true)
	audio_vol_master = value

func _on_VolMusic_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	if value > -48:
		AudioServer.set_bus_mute(1, false)
	elif value <= -48:
		AudioServer.set_bus_mute(1, true)
	audio_vol_music = value

func _on_VolSFX_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	if value > -48:
		AudioServer.set_bus_mute(2, false)
	elif value <= -48:
		AudioServer.set_bus_mute(2, true)
	audio_vol_sfx = value

func _on_VolAmbience_value_changed(value):
	AudioServer.set_bus_volume_db(3, value)
	if value > -48:
		AudioServer.set_bus_mute(3, false)
	elif value <= -48:
		AudioServer.set_bus_mute(3, true)
		audio_vol_ambience = value

func _on_VolVoice_value_changed(value):
	AudioServer.set_bus_volume_db(4, value)
	if value > -48:
		AudioServer.set_bus_mute(4, false)
	elif value <= -48:
		AudioServer.set_bus_mute(4, true)
	audio_vol_voice = value

func _on_VolRadio_value_changed(value):
	AudioServer.set_bus_volume_db(5, value)
	if value > -48:
		AudioServer.set_bus_mute(5, false)
	elif value <= -48:
		AudioServer.set_bus_mute(5, true)
	audio_vol_radio = value

func _on_VolUI_value_changed(value):
	AudioServer.set_bus_volume_db(6, value)
	if value > -48:
		AudioServer.set_bus_mute(6, false)
	elif value <= -48:
		AudioServer.set_bus_mute(6, true)
	audio_vol_ui = value

#func _on_HSlider_value_changed(value):
#	AudioServer.set_bus_volume_db(0, value)
#	if value > -48:
#		AudioServer.set_bus_mute(0, false)
#	elif value <= -48:
#		AudioServer.set_bus_mute(0, true)



### Debug Settings ###
func _on_check_box_toggled(toggled_on):
	Cheats.slowmo_enabled = toggled_on
	Cheats.slowmo()



func _on_Shell_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))


func _on_Shell2_pressed():
	OS.shell_open(ProjectSettings.globalize_path("res://"))

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"view_bob": view_bob,
		"display_current_resolution": display_current_resolution,
		"audio_vol_master": audio_vol_master,
		"audio_vol_music": audio_vol_music,
		"audio_vol_sfx": audio_vol_sfx,
		"audio_vol_ambience": audio_vol_ambience,
		"audio_vol_voice": audio_vol_voice,
		"audio_vol_radio": audio_vol_radio,
		"audio_vol_ui": audio_vol_ui,
	}
	return save_dict
