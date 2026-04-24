extends Control

var levels_dir = GameMaster.levels_folder # Point of reliance on other singleton. Not modular.

@onready var item_list_levels: ItemList = $ItemListLevels
@onready var line_edit: LineEdit = $HBox/LineEdit
@onready var button_play_level: Button = $HBox/ButtonPlayLevel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_level_list()


func populate_level_list():
	item_list_levels.clear() # Flush the level selector list to refresh for newer directories if added at runtime.
	for f in DirAccess.get_directories_at(levels_dir):
		item_list_levels.add_item(f)
	#print("LevelSelector: ", ResourceLoader.get_recognized_extensions_for_type(".tscn"))
	#for folder in levels_dir:
		#item_list_levels.add_item(folder)

func _on_item_list_level_selected(index: int) -> void:
	line_edit.text = item_list_levels.get_item_text(index)


func _on_button_play_level_pressed() -> void:
	GameMaster.level_transfer_method = 0
	GameMaster.load_level(line_edit.text)
	ScoreCounter.coins -= 10
