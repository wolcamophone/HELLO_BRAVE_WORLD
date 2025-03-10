extends Control

#region Gameplay Menu Vars ###
var skip_intro_cutscene:bool = false
var set_player_color:Color = "ffffff"
var set_emission_color:Color = "000000"
#endregion

#region Video Menu Vars ###
@onready var res_button: OptionButton = $"VBox/Tabs/Video/HBox/VBox/HBox/ResButton"
@onready var fullscreen_button: CheckBox = $"VBox/Tabs/Video/HBox/VBox/FullscreenCheck"
@onready var v_sync_button: CheckBox = $"VBox/Tabs/Video/HBox/VBox/V-Sync"
@onready var save_settings_button: Button = $"VBox/SaveSettings"

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
# Check this against save func later to see if .json supports Vector2
var current_display_resolution:Vector2i
var fullscreen_on:bool = false
var view_bob:bool = true
var vignette_enabled:bool = true
#endregion

#region Audio Menu Vars
var audio_vol_master:int = 0
var audio_vol_music:int = -12
var audio_vol_sfx:int = 0
var audio_vol_ambience:int = 0
var audio_vol_voice:int = 0
var audio_vol_radio:int = 0
var audio_vol_ui:int = 0
#endregion

#region Debug Menu Vars
#endregion

#region Save Settings Config Vars
var save_settings_config:ConfigFile = ConfigFile.new()
var load_settings_config:ConfigFile = ConfigFile.new()
var save_settings_path = "user://settings.cfg"
#endregion



func _ready():
	AddResolutions()


#region Gameplay Settings Funcs
func _on_skip_intro_cutscene_toggled(toggled_on: bool) -> void:
	SettingsConfig.skip_intro_cutscene = toggled_on
	GameMaster.skip_intro_cutscene = skip_intro_cutscene

func _on_player_color_changed(color_arg: Color) -> void:
	SettingsConfig.player_color = color_arg
	if GameMaster.active_player:
		GameMaster.active_player.player_model.player_mesh.material_override.albedo_color = set_player_color

func _on_player_emission_changed(color_arg: Color) -> void:
	SettingsConfig.emission_color = color_arg
	if GameMaster.active_player:
		GameMaster.active_player.player_model.player_mesh.material_override.emission = set_emission_color
#endregion


#region Video Settings Funcs
func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func AddResolutions():
	for r in Resolutions:
		res_button.add_item(r)

func _on_ResButton_item_selected(index): 
	# Gets Vector 2 from dropdown menu then resizes window.
	var size = res_button.get_item_text(index)
	get_window().set_size(Resolutions[size])
	current_display_resolution = Resolutions[size]

func _on_VSync_toggled(button_pressed):
	SettingsConfig
	DisplayServer.window_set_vsync_mode(button_pressed)

func _on_view_bob_toggled(toggled_on):
	SettingsConfig.view_bob = toggled_on
	GameMaster.active_player.view_bob = SettingsConfig.view_bob

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
	elif !button_pressed:
		var CursorM = load("res://Graphics/UI/CursorM.png")
		Input.set_custom_mouse_cursor(CursorM)

func _on_vignette_toggled(toggled_on: bool) -> void:
	SettingsConfig.vignette_enabled = toggled_on
	HUD._vignette.visible = vignette_enabled
#endregion


#region Audio Settings Funcs
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
#endregion


#region Debug Settings Funcs
func _on_check_box_toggled(toggled_on):
	Cheats.slowmo_enabled = toggled_on
	Cheats.slowmo()

func _on_Shell_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func _on_Shell2_pressed():
	OS.shell_open(ProjectSettings.globalize_path("res://"))
#endregion


#region Save/Load Config
func save_settings():
	save_settings_config.set_value("Gameplay", "skip_intro_cutscene", skip_intro_cutscene)
	save_settings_config.set_value("Gameplay", "player_color", set_player_color)
	save_settings_config.set_value("Gameplay", "emission_color", set_emission_color)
	
	save_settings_config.set_value("Video", "fullscreen_on", fullscreen_on)
	save_settings_config.set_value("Video", "view_bob", view_bob)
	save_settings_config.set_value("Video", "vignette_enabled", vignette_enabled)
	save_settings_config.set_value("Video", "current_display_resolution", current_display_resolution)
	
	save_settings_config.set_value("Audio", "audio_vol_master", audio_vol_master)
	save_settings_config.set_value("Audio", "audio_vol_music", audio_vol_music)
	save_settings_config.set_value("Audio", "audio_vol_sfx", audio_vol_sfx)
	save_settings_config.set_value("Audio", "audio_vol_ambience", audio_vol_ambience)
	save_settings_config.set_value("Audio", "audio_vol_voice", audio_vol_voice)
	save_settings_config.set_value("Audio", "audio_vol_radio", audio_vol_radio)
	save_settings_config.set_value("Audio", "audio_vol_ui", audio_vol_ui)
	
	save_settings_config.save(save_settings_path)

func load_settings():
	var load_settings_data = load_settings_config.load(save_settings_path)
	
	if load_settings_data == OK:
		skip_intro_cutscene = load_settings_config.get_value("Gameplay", "skip_intro_cutscene")
		set_player_color = load_settings_config.get_value("Gameplay", "player_color")
		set_emission_color = load_settings_config.get_value("Gameplay", "emission_color")
		
		fullscreen_on = load_settings_config.get_value("Video", "fullscreen_on")
		view_bob = load_settings_config.get_value("Video", "view_bob")
		vignette_enabled = load_settings_config.get_value("Video", "vignette_enabled")
		current_display_resolution = load_settings_config.get_value("Video", "current_display_resolution")
		
		audio_vol_master = load_settings_config.get_value("Audio", "audio_vol_master")
		audio_vol_music = load_settings_config.get_value("Audio", "audio_vol_music")
		audio_vol_sfx = load_settings_config.get_value("Audio", "audio_vol_sfx")
		audio_vol_ambience = load_settings_config.get_value("Audio", "audio_vol_ambience")
		audio_vol_voice = load_settings_config.get_value("Audio", "audio_vol_voice")
		audio_vol_radio = load_settings_config.get_value("Audio", "audio_vol_radio")
		audio_vol_ui = load_settings_config.get_value("Audio", "audio_vol_ui")
		
		call("_on_player_color_changed")
		call("_on_player_emission_changed")
	else:
		printerr("File provided was not a valid settings.cfg file!")
#endregion
