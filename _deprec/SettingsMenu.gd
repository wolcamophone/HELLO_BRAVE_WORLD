extends Node

onready var ResButton = $TabContainer/Video/HBoxContainer/VBoxContainer/ResButton
onready var FullscreenToggle = $TabContainer/Video/HBoxContainer/VBoxContainer/Fullscreen

var Resolutions: Dictionary = {
	"[4:3] 800x600": Vector2(800,600),
	"[16:9] 1024x600":Vector2(1024,600),
	"[16:9] 1280x720":Vector2(1280,720),
	"[16:9] 1366x768":Vector2(1366,768),
	"[4:3] 1440x900":Vector2(1440,900),
	"[16:9] 1536x864":Vector2(1536,864),
	"[16:9] 1600x900":Vector2(1600,900),
	"[16:9] 1920x1080":Vector2(1920,1080),
	"[16:9] 2560x1440":Vector2(2560,1440),
	"[16:9] 3840x2160":Vector2(3840,2160)
}

var CursorM = load("res://Graphics/UI/CursorM.png")
var CursorL = load("res://Graphics/UI/CursorL.png")



func _ready():
	AddResolutions()
	FullscreenToggle.pressed = OS.is_window_fullscreen()
	
func AddResolutions():
	var CurrentResolution = get_viewport().get_size()
	var Index = 0
	for r in Resolutions:
		ResButton.add_item(r, Index)
		if Resolutions[r] == CurrentResolution:
			ResButton._select_int(Index)
		Index += 1

func _on_ResButton_item_selected(index): 
	# Gets Vector 2 from dropdown menu then resizes window.
	var size = Resolutions.get(ResButton.get_item_text(index))
	OS.set_window_size(size)
	OS.center_window()
	print(OS.get_real_window_size())
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,SceneTree.STRETCH_ASPECT_KEEP,size)
#	if OS.window_fullscreen:
#		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT,SceneTree.STRETCH_ASPECT_KEEP,size) 
#	elif not OS.window_fullscreen:
#		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED,SceneTree.STRETCH_ASPECT_IGNORE,size)
	# Keeps window at resolution even when maximized.

func _on_Fullscreen_toggled(button_pressed):
	# Toggles fullscreen
	OS.set_window_fullscreen(button_pressed)
	if not button_pressed:
		var size = get_viewport().get_size()
		OS.set_window_size(size)
		OS.center_window()



func _on_VSync_toggled(button_pressed):
	OS.set_use_vsync(button_pressed)

func _on_AntiAlias_item_selected(index):
	get_viewport().set_msaa(index)
	if index == 5:
		get_viewport().set_use_fxaa(true)
		get_viewport().set_msaa(0)
	else:
		get_viewport().set_use_fxaa(false)

func _on_LargeCursor_toggled(button_pressed):
	if button_pressed:
		Input.set_custom_mouse_cursor(CursorL)
	elif not button_pressed:
		Input.set_custom_mouse_cursor(CursorM)




### Audio Settings. ###

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	if value > -48:
		AudioServer.set_bus_mute(0, false)
	elif value <= -48:
		AudioServer.set_bus_mute(0, true)

func _on_VolMusic_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
	if value > -48:
		AudioServer.set_bus_mute(1, false)
	elif value <= -48:
		AudioServer.set_bus_mute(1, true)
		
func _on_VolSFX_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)
	if value > -48:
		AudioServer.set_bus_mute(2, false)
	elif value <= -48:
		AudioServer.set_bus_mute(2, true)

func _on_VolRadio_value_changed(value):
	AudioServer.set_bus_volume_db(5, value)
	if value > -48:
		AudioServer.set_bus_mute(5, false)
	elif value <= -48:
		AudioServer.set_bus_mute(5, true)

func _on_VolAmbience_value_changed(value):
	AudioServer.set_bus_volume_db(3, value)
	if value > -48:
		AudioServer.set_bus_mute(3, false)
	elif value <= -48:
		AudioServer.set_bus_mute(3, true)

func _on_VolUI_value_changed(value):
	AudioServer.set_bus_volume_db(6, value)
	if value > -48:
		AudioServer.set_bus_mute(6, false)
	elif value <= -48:
		AudioServer.set_bus_mute(6, true)

func _on_VolVoice_value_changed(value):
	AudioServer.set_bus_volume_db(4, value)
	if value > -48:
		AudioServer.set_bus_mute(4, false)
	elif value <= -48:
		AudioServer.set_bus_mute(4, true)



func _on_Close_pressed():
	self.visible = false


func _on_Shell_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))


func _on_Shell2_pressed():
	OS.shell_open(ProjectSettings.globalize_path("res://"))



