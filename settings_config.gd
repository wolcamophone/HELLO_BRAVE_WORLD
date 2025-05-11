extends Node

#region Vars (There's a lot of em!)
# Gameplay
@export var skip_intro_cutscene:bool = false
@export var player_color:Color = "ffffff"
@export var emission_color:Color = "000000"

# Video 
var current_display_resolution:Vector2i
@export var fullscreen_on:bool = false
@export var vsync_enabled:int = true # this ideally would be a bool but DisplayServer.VSyncMode complains and won't parse a bool because there are different methods of v-sync available.
@export var fov_desired:int = 80
@export var view_bob:bool = true
@export var anti_alias_index:int = 0
@export var occlusion_culling:bool = true
@export var vignette_enabled:bool = true

# Audio
@export var audio_vol_master:int = 0
@export var audio_vol_music:int = -12
@export var audio_vol_sfx:int = 0
@export var audio_vol_ambience:int = 0
@export var audio_vol_voice:int = 0
@export var audio_vol_radio:int = 0
@export var audio_vol_ui:int = 0

# Debug
@export var print_func_calls:bool = true # TODO: Change to false for full release game.

# Save/Load
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
	save_settings_config.set_value("Video", "vsync_enabled", vsync_enabled)
	save_settings_config.set_value("Video", "fov_desired", fov_desired)
	save_settings_config.set_value("Video", "view_bob", view_bob)
	save_settings_config.set_value("Video", "anti_alias_index", anti_alias_index)
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
		vsync_enabled = load_settings_config.get_value("Video", "vsync_enabled")
		fov_desired = load_settings_config.get_value("Video", "fov_desired")
		view_bob = load_settings_config.get_value("Video", "view_bob")
		anti_alias_index = load_settings_config.get_value("Video", "anti_alias_index")
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
		
		update_to_current_settings()
	else:
		printerr("settings.cfg file not provided! Saving settings as default to cfg")
#endregion

func update_to_current_settings():
	# Fullscreen
	if fullscreen_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif !fullscreen_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	# Vertical Sync
	DisplayServer.window_set_vsync_mode(vsync_enabled)
	# View Bob
	GameMaster.active_player.view_bob = view_bob
	# Anti Aliasing
	get_viewport().set_msaa(anti_alias_index)
	if anti_alias_index == 5:
		get_viewport().set_use_fxaa(true)
		get_viewport().set_msaa(0)
	else:
		get_viewport().set_use_fxaa(false)
	# Vignette
	HUD._vignette.visible = vignette_enabled
	
