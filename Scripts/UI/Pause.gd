extends Control

export var paused = false

onready var SettingsMenu = $SettingsMenu
#onready var Console = $Console

func _ready():
	paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	pass

func _unhandled_input(event):
	if not paused and event.is_action_pressed("Pause"): 
			# Pauses
			paused = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Cont/VBox/Resume.grab_focus()
			self.visible = true
			print("Paused")
	elif paused and event.is_action_pressed("Pause") or event.is_action_pressed("ui_cancel"):
			# Unpauses
			paused = false
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.visible = false
			print("Unpaused")


func _on_Resume_pressed():
	# Unpauses
	paused = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	print("Unpaused")

func _on_Quit_pressed():
	get_tree().quit()
	

func _on_Settings_pressed():
	SettingsMenu.visible = true
