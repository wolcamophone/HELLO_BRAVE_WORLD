extends Node

## You never saw this...

var fun_score:int = -1
var thyme:Timer

func _ready() -> void:
	if fun_score == -1:
		fun_score = randi() % 100
	
	holidays()
	chance_open_photos_folder()

func _process(delta: float) -> void:
	pass

func dice_roller(dice, range):
	var total:int
	for d in dice:
		d = randi_range(1, range)
		print(d)
		total += d
	print(total)

func chance_open_photos_folder():
	var user_profile = OS.get_environment("UserProfile")
	var d = randi() % 24
	if d == 0:
		OS.shell_open(user_profile + "/Pictures")
	elif d == 3:
		print("Into the flood again")

func holidays():
	var occasion = Time.get_date_dict_from_system()
	print(occasion)
	
	if occasion.month == 12 && occasion.day == 25:
		print("Happy Christmas! War is Over!")
	if occasion.month == 10 && occasion.day == 31:
		print("Sp00k!")
	if occasion.month == 12 && occasion.day == 31:
		print("It's the Final Countdown!")
	if occasion.month == 12 && occasion.day == 16:
		print("Born!")
	
func mute_all():
	AudioServer.set_bus_mute(0, true)
	
