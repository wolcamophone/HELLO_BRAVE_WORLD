extends CanvasLayer

var checkpoint_name_current:String = GameMaster.checkpoint_current_name
var checkpoint_list_current:Array = GameMaster.checkpoints_available
var status_report

# Checkpoint Menu
@onready var menu_container: PanelContainer = $Control/MenuContainer
@onready var label_level_name: Label = $Control/MenuContainer/VBoxContainer/LabelLevelName
@onready var label_checkpoint_name: Label = $Control/MenuContainer/VBoxContainer/LabelCheckpointName
# Buttons
@onready var travel: Button = $Control/MenuContainer/VBoxContainer/Travel
@onready var save: Button = $Control/MenuContainer/VBoxContainer/Save
@onready var status_report_button: Button = $Control/MenuContainer/VBoxContainer/StatusReport
@onready var close: Button = $Control/MenuContainer/VBoxContainer/Close


# Travel Menu
@onready var travel_container: TabContainer = $Control/TravelContainer
@onready var travel_locations_list: ItemList = $Control/TravelContainer/Checkpoint/ItemList
# Buttons
@onready var close2: Button = $Control/TravelContainer/Checkpoint/Close



func _ready() -> void:
	self.visible = false
	close.connect("pressed",_close_menu)
	close2.connect("pressed",_close_travel_menu)
	travel.connect("pressed",_show_travel_menu)

func update_checkpoints_list():
	# Clears, then adds checkpoints available in the GM to the travel_locations_list items. 
	travel_locations_list.clear()
	for candidate in GameMaster.checkpoints_available:
		travel_locations_list.add_item(candidate.name)
		if candidate.claimed == false:
			travel_locations_list.set_item_disabled(candidate.get_index(), true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close_menu()

func _show_menu():
	update_checkpoints_list()
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	travel.grab_focus()

#region Handling of Travel Menu.
func _show_travel_menu():
	travel_container.visible = true

func _on_travel_menu_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var index_pos_rot:Vector4
	GameMaster.teleport(GameMaster.checkpoints_available[index])
	for candidate in GameMaster.checkpoints_available:
		candidate.change_mesh()
	ScoreCounter.coins -= 1
	_close_menu()

func _close_travel_menu():
	travel_container.visible = false
#endregion

func _on_save_pressed() -> void:
	GameMaster.save_game_as_cfg()
	_close_menu()

func _prompt_status_report(): ## Displays a text box file specified by status_report to give the player updates.
	Dialogic.start(status_report)

func _close_menu() -> void:
	_close_travel_menu()
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#get_tree().paused = false 
	
