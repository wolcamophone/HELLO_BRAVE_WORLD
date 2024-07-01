extends Node3D
class_name Level

@onready var lvl_env:WorldEnvironment = $WorldEnvironment
@onready var lvl_sun:DirectionalLight3D = $DirectionalLight3D
@onready var lvl_map:FuncGodotMap = $FuncGodotMap
#@onready var lvl_def_spawnpoint:InfoPlayerStart = $InfoPlayerStart
@onready var main_ambience = $AmbientTrack
@onready var main_music:AudioStreamPlayer3D = $MusicTrack

