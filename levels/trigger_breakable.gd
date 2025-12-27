extends StaticBody3D

@export_enum("generic","metal","glass","wood","stone","flesh") var material_flavor = 0 # Determines which gibbs spawn and what sound effects play when the object shatters. 
@export var health:int = 10 # How much damage the object can take. Triggers the shatter when this reaches 0 or below.
@export var broken:bool = 0 # If true, the object is already shattered and won't process damage any longer.

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

@export var sfx_generic:AudioStream = preload("res://audio/SFX/GlassBreak.ogg")
var sfx_glass:AudioStream = preload("res://audio/SFX/GlassBreak.ogg")

var sfx_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()

func _ready() -> void:
	sfx_player.stream = sfx_generic
	#var s = sfx_player.instantiate()
	#add_child(s)

func damage():
	if health <= 0:
		shatter()

func shatter():
	if material_flavor == 0:
		sfx_player.play()
