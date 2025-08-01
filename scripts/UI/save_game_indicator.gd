extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var notif_sound: AudioStreamPlayer = $NotifSound

@onready var saving_label: Label = $Control/SavingLabel
@onready var loading_label: Label = $Control/LoadingLabel

func _ready() -> void:
	saving_label.visible = false
	loading_label.visible = false

func show_indicator(indicator):
	if indicator == "save":
		saving_label.visible = true
		notif()
	elif indicator == "load":
		loading_label.visible = true
		notif()
	else:
		print("SaveGameIndicator: invalid indicator type passed")

func notif():
	notif_sound.play()
	timer.start(4.0)

func hide_indicator(): # Signaled on timer timeout
	saving_label.visible = false
	loading_label.visible = false
