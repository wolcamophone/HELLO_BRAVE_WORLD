extends PanelContainer

# I am sure there is a way to redo this menu with incremental instantiated scenes and an index, but for now setting up all 4 slots manually works.

# Save File 1
@onready var save_thumbnail_1: TextureRect = $VBox/HBoxTop/VBoxFile1/SaveThumbnail
@onready var level_name_label_1: Label = $VBox/HBoxTop/VBoxFile1/LevelNameLabel
@onready var save_file_1: Button = $VBox/HBoxTop/VBoxFile1/SaveFile1
@onready var load_file_1: Button = $VBox/HBoxTop/VBoxFile1/LoadFile1

# Save File 2
@onready var save_thumbnail_2: TextureRect = $VBox/HBoxTop/VBoxFile2/SaveThumbnail
@onready var level_name_label_2: Label = $VBox/HBoxTop/VBoxFile2/LevelNameLabel
@onready var save_file_2: Button = $VBox/HBoxTop/VBoxFile2/SaveFile2
@onready var load_file_2: Button = $VBox/HBoxTop/VBoxFile2/LoadFile2

# Save File 3
@onready var save_thumbnail_3: TextureRect = $VBox/HBoxBottom/VBoxFile1/SaveThumbnail
@onready var level_name_label_3: Label = $VBox/HBoxBottom/VBoxFile1/LevelNameLabel
@onready var save_file_3: Button = $VBox/HBoxBottom/VBoxFile1/SaveFile3
@onready var load_file_3: Button = $VBox/HBoxBottom/VBoxFile1/LoadFile3

# Save File 4
@onready var save_thumbnail_4: TextureRect = $VBox/HBoxBottom/VBoxFile2/SaveThumbnail
@onready var level_name_label_4: Label = $VBox/HBoxBottom/VBoxFile2/LevelNameLabel
@onready var save_file_4: Button = $VBox/HBoxBottom/VBoxFile2/SaveFile4
@onready var load_file_4: Button = $VBox/HBoxBottom/VBoxFile2/LoadFile4


func _ready() -> void:
	pass # Replace with function body.
	level_name_label_1
	level_name_label_2
	level_name_label_3
	level_name_label_4


func index_for_saves():
	pass
	# TODO: Check for available save files in user data, skim level_name and thumbnail of save slot, setup for loop to update TextureRect and Label with thumbnail and level_name. use GameMaster.save_game_path and GameMaster.current_save_slot

func load_selected_game():
	pass
	# TODO: 

#region Individual Save Button Funcs
func _on_save_file_1_pressed() -> void:
	pass # Replace with function body.

func _on_save_file_2_pressed() -> void:
	pass # Replace with function body.

func _on_save_file_3_pressed() -> void:
	pass # Replace with function body.

func _on_save_file_4_pressed() -> void:
	pass # Replace with function body.
#endregion
