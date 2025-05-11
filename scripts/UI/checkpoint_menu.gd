extends CanvasLayer

var checkpoint_name_current:String = GameMaster.checkpoint_current_name
var checkpoint_list_current:Dictionary = GameMaster.checkpoints_available

## Checkpoint Menu
@onready var menu_container: PanelContainer = $Control/MenuContainer
@onready var label_level_name: Label = $Control/MenuContainer/VBoxContainer/LabelLevelName
@onready var label_checkpoint_name: Label = $Control/MenuContainer/VBoxContainer/LabelCheckpointName
# Buttons
@onready var travel: Button = $Control/MenuContainer/VBoxContainer/Travel
@onready var save: Button = $Control/MenuContainer/VBoxContainer/Save
@onready var status_report_button: Button = $Control/MenuContainer/VBoxContainer/StatusReport
@onready var close: Button = $Control/MenuContainer/VBoxContainer/Close
@onready var travel_locations_list: ItemList = $Control/TravelContainer/VBoxContainer2/ItemList

## Travel Menu
@onready var travel_container: PanelContainer = $Control/TravelContainer
# Buttons
@onready var close2: Button = $Control/TravelContainer/VBoxContainer2/Close

var status_report

func _ready() -> void:
	self.visible = false
	close.connect("pressed",_close_menu)
	close2.connect("pressed",_close_travel_menu)
	
	travel.connect("pressed",_show_travel_menu)
	
	# TODO: This should add all available checkpoints in the level (or at least this dict) as items to be selected from the items list. Will need to add code to handle traveling to name of checkpoint selected.
	for txt in GameMaster.checkpoints_available:
		travel_locations_list.add_item(txt)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close_menu()

func _show_menu():
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	travel.grab_focus()

func _show_travel_menu():
	travel_container.visible = true

func _close_travel_menu():
	travel_container.visible = false

func _on_save_pressed() -> void:
	GameMaster.save_as_cfg()

func _prompt_status_report():
	Dialogic.start(status_report)

func _close_menu() -> void:
	_close_travel_menu()
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#get_tree().paused = false # TODO
	
