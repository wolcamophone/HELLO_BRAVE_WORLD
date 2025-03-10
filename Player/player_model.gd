extends Node3D
class_name PlayerModel

### This class should be used to export any mesh values for the player to tweak.
@export var player_color:Color = "ffffff"
@export var emission_color:Color = "000000"
@export var player_mesh:GeometryInstance3D

func _ready() -> void:
	player_mesh.material_override.albedo_color = SettingsConfig.player_color
	player_mesh.material_override.emission = SettingsConfig.emission_color
	pass
