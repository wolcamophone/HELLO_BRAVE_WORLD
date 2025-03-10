extends Node

#region Gameplay Vars
@export var skip_intro_cutscene:bool = false
@export var player_color:Color = "ffffff"
@export var emission_color:Color = "000000"
#endregion

#region Video Vars
var current_display_resolution:Vector2i
@export var fullscreen_on:bool = false
@export var vsync_enabled:bool = true
@export var view_bob:bool = true
@export var occlusion_culling:bool = true
@export var vignette_enabled:bool = true
#endregion

#region Audio Vars
@export_category("Audio Menu Vars")
@export var audio_vol_master:int = 0
@export var audio_vol_music:int = -12
@export var audio_vol_sfx:int = 0
@export var audio_vol_ambience:int = 0
@export var audio_vol_voice:int = 0
@export var audio_vol_radio:int = 0
@export var audio_vol_ui:int = 0
#endregion

#region Debug Menu Vars
#endregion

#region Save Settings Config Vars
var save_settings_config:ConfigFile = ConfigFile.new()
var load_settings_config:ConfigFile = ConfigFile.new()
var save_settings_path = "user://settings.cfg"
#endregion

func _ready() -> void:
	print()
	pass

#region Save/Load Funcs
func save_settings():
	# Gameplay Values
	save_settings_config.set_value("Gameplay", "skip_intro_cutscene", skip_intro_cutscene)
	save_settings_config.set_value("Gameplay", "player_color", player_color)
	save_settings_config.set_value("Gameplay", "emission_color", emission_color)
	# Video Values
	save_settings_config.set_value("Video", "fullscreen_on", fullscreen_on)
	save_settings_config.set_value("Video", "view_bob", view_bob)
	save_settings_config.set_value("Video", "vignette_enabled", vignette_enabled)
	save_settings_config.set_value("Video", "current_display_resolution", current_display_resolution)
	# Audio Values
	save_settings_config.set_value("Audio", "audio_vol_master", audio_vol_master)
	save_settings_config.set_value("Audio", "audio_vol_music", audio_vol_music)
	save_settings_config.set_value("Audio", "audio_vol_sfx", audio_vol_sfx)
	save_settings_config.set_value("Audio", "audio_vol_ambience", audio_vol_ambience)
	save_settings_config.set_value("Audio", "audio_vol_voice", audio_vol_voice)
	save_settings_config.set_value("Audio", "audio_vol_radio", audio_vol_radio)
	save_settings_config.set_value("Audio", "audio_vol_ui", audio_vol_ui)
	# Debug Values (if any)
	
	save_settings_config.save(save_settings_path)

func load_settings():
	var load_settings_data = load_settings_config.load(save_settings_path)
	
	if load_settings_data == OK:
		# Gameplay Values Recall
		skip_intro_cutscene = load_settings_config.get_value("Gameplay", "skip_intro_cutscene")
		player_color = load_settings_config.get_value("Gameplay", "player_color")
		emission_color = load_settings_config.get_value("Gameplay", "emission_color")
		# Video Values Recall
		fullscreen_on = load_settings_config.get_value("Video", "fullscreen_on")
		view_bob = load_settings_config.get_value("Video", "view_bob")
		vignette_enabled = load_settings_config.get_value("Video", "vignette_enabled")
		current_display_resolution = load_settings_config.get_value("Video", "current_display_resolution")
		# Audio Values Recall
		audio_vol_master = load_settings_config.get_value("Audio", "audio_vol_master")
		audio_vol_music = load_settings_config.get_value("Audio", "audio_vol_music")
		audio_vol_sfx = load_settings_config.get_value("Audio", "audio_vol_sfx")
		audio_vol_ambience = load_settings_config.get_value("Audio", "audio_vol_ambience")
		audio_vol_voice = load_settings_config.get_value("Audio", "audio_vol_voice")
		audio_vol_radio = load_settings_config.get_value("Audio", "audio_vol_radio")
		audio_vol_ui = load_settings_config.get_value("Audio", "audio_vol_ui")
		# Debug Values Recall (if any)
	else:
		printerr("File provided was not a valid settings.cfg file!")
#endregion
