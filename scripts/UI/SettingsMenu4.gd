extends Control

#region Gameplay Menu Vars ###
var player_skins_folder = "res://Player/player_skins/"
var player_skin_default:StandardMaterial3D = preload("res://Player/player_skins/android.material")

var skip_intro_cutscene:bool = false
var set_player_color:Color = "ffffff"
var set_emission_color:Color = "000000"

#@onready var player_accessed_color = GameMaster.active_player._player_mesh.material_override.albedo_color
#@onready var player_accessed_emission = GameMaster.active_player._player_mesh.material_override.emission
#@onready var player_accessed_lamp_color = GameMaster.active_player.omni_light_3d_tattoo.light_color
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

@export var debug_mode:bool = false
#endregion

#region Save Settings Config Vars
var save_settings_config:ConfigFile = ConfigFile.new()
var load_settings_config:ConfigFile = ConfigFile.new()
var save_settings_path = "user://settings.cfg"
#endregion



func _ready():
	AddResolutions()
	SettingsConfig.load_settings()


#region Gameplay Settings Funcs
func _on_skip_intro_cutscene_toggled(toggled_on: bool) -> void:
	SettingsConfig.skip_intro_cutscene = toggled_on

func _on_change_player_skin() -> void:
	if GameMaster.active_player != null:
		GameMaster.active_player._player_mesh.material_override = player_skin_default

func _on_player_color_changed(color_arg: Color) -> void:
	# The code here is adjusting the material_override property of the GeometryInstance3D of the player, NOT the material assigned to the mesh's inherent surface_0 or surface_material_override/0! I do not know how to access the other two properties.
	SettingsConfig.player_color = color_arg
	if GameMaster.active_player != null:
		GameMaster.active_player._player_mesh.material_override.albedo_color = color_arg

func _on_player_emission_changed(color_arg: Color) -> void:
	SettingsConfig.emission_color = color_arg
	if GameMaster.active_player != null:
		GameMaster.active_player._player_mesh.material_override.emission = color_arg 
		GameMaster.active_player.omni_light_3d_tattoo.light_color = color_arg
#endregion


#region Video Settings Funcs
func _on_fullscreen_toggled(toggled_on):
	SettingsConfig.fullscreen_on = toggled_on
	
	if !toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func AddResolutions():
	for r in Resolutions:
		res_button.add_item(r)

func _on_ResButton_item_selected(index): 
	# Gets Vector 2 from dropdown menu then resizes window.
	var size = res_button.get_item_text(index)
	get_window().set_size(Resolutions[size])
	current_display_resolution = Resolutions[size]

func _on_VSync_toggled(button_pressed):
	SettingsConfig.vsync_enabled = button_pressed
	DisplayServer.window_set_vsync_mode(button_pressed)

func _on_view_bob_toggled(toggled_on):
	SettingsConfig.view_bob = toggled_on
	GameMaster.active_player.view_bob = SettingsConfig.view_bob

func _on_AntiAlias_item_selected(index):
	SettingsConfig.anti_alias_index = index
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
	HUD._vignette.visible = SettingsConfig.vignette_enabled
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


func _on_slowmo_toggled(toggled_on: bool) -> void:
	Cheats.slowmo_enabled = toggled_on
	Cheats.slowmo()

func _on_slider_slowmo_value_changed(value: float) -> void:
	Cheats.slowmo_timescale = value
	Cheats.slowmo()

func _on_check_box_inf_jumps_toggled(toggled_on: bool) -> void:
	Cheats.infinite_double_jumps = toggled_on
	Cheats.inf_double_jumps()

func _on_check_box_inf_karma_toggled(toggled_on: bool) -> void:
	Cheats.infinite_karma = toggled_on

func _on_display_debug_toggled(toggled_on: bool) -> void:
	HUD.show_debug_hud = toggled_on
	HUD.update_debug_vis()

func _on_Shell_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func _on_Shell2_pressed():
	OS.shell_open(ProjectSettings.globalize_path("res://"))

#endregion


func _on_save_settings_pressed() -> void:
	SettingsConfig.save_settings()
