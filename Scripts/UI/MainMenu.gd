extends CanvasLayer

@export var paused = false
@onready var main_menu_tab:Control = $Control/TabContainer/MainMenu
@onready var start_button:Control = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Start
@onready var title_button:Control = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Title
@onready var save_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Save
@onready var load_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/Load
@onready var to_movement_test_button: Button = $Control/TabContainer/MainMenu/HBox/PanelContainer/VBox/ToMovementTest


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main Menu loaded!")
	paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false


func _unhandled_input(event):
	if !paused && event.is_action_pressed("Pause"): 
		pause_game()
	elif paused && event.is_action_pressed("Pause") or event.is_action_pressed("ui_cancel"):
		unpause_game()


func _on_resume_pressed():
	unpause_game()
func _on_quit_pressed():
#	get_tree().quit()
#	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
#	SceneTree.quit()
	GameMaster.quit_game()
func _on_start_pressed():
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
	GameMaster.load_level("movement_testing")
	unpause_game()


func pause_game():
	paused = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	$Cont/VBox/Resume.grab_focus()
	self.visible = true
	print("Paused")


func unpause_game():
	paused = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	print("Unpaused")
