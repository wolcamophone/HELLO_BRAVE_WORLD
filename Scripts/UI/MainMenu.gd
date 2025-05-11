extends CanvasLayer

@export var paused = false
@onready var main_menu: TabContainer = $Control/TabContainer
@onready var main_menu_tab:Control = $Control/TabContainer/MainMenu
@onready var resume_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Resume
@onready var start_button:Control = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Start
@onready var title_button:Control = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Title
@onready var save_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Save
@onready var load_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Load
@onready var to_movement_test_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/ToMovementTest

var submenues_active:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main Menu loaded!")
	paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	
	main_menu.set_anchors_preset(Control.PRESET_CENTER)
	
	resume_button.pressed.connect(_on_resume_pressed)
	start_button.pressed.connect(_on_start_pressed)
	title_button.pressed.connect(_on_title_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	to_movement_test_button.pressed.connect(_on_to_movement_test_pressed)


func _unhandled_input(event):
	if !paused && event.is_action_pressed("Pause") && CheckpointMenu.visible==false: 
		pause_game()
	elif paused && event.is_action_pressed("Pause") or event.is_action_pressed("ui_cancel"):
		unpause_game()


func _on_resume_pressed():
	unpause_game()
func _on_quit_pressed():
	GameMaster.quit_game()
func _on_start_pressed():
	#GameMaster.level_transfer_destination = null
	GameMaster.level_transfer_destination = Vector4(-8,8.6,-21,-105) # TODO: This is a temporary fix to insure the player doesn't spawn in the void when transferring from a level with far away coordinates.
	GameMaster.load_level("hub_world")
	unpause_game()
func _on_save_pressed():
	GameMaster.save_game_as_cfg()
func _on_load_pressed():
	GameMaster.load_game_from_cfg()
func _on_title_pressed():
	GameMaster.load_level("boot_menu")
	unpause_game()
func _on_to_movement_test_pressed():
	GameMaster.level_transfer_destination = Vector4(0,0.1,0,0) # TODO: This is a temporary fix
	GameMaster.load_level("movement_testing")
	unpause_game()


func pause_game():
	paused = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main_menu.current_tab = 0
	resume_button.grab_focus()
	self.visible = true
	print("Paused")


func unpause_game():
	paused = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	print("Unpaused")
