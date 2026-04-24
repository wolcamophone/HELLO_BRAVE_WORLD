extends Area3D
class_name AreaLevelTransfer

@export var transfer_to_level:String
@export var transfer_to_position:Vector4

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area:Area3D):
	if area.is_in_group("player"):
		GameMaster.load_level(transfer_to_level, 1)
		GameMaster.level_transfer_destination = transfer_to_position
