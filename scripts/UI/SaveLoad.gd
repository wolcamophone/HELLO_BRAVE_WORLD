extends TabContainer

var path = "user://data.json"

var default_data = {
	"settings" : {
		"video" : {
			"fullscreen" : false,
			},
		"audio" : {
			"vol_master" : 0,
			"vol_music" : 0,
			"vol_sfx" : 0,
			"vol_voice" : 0,
			"vol_radio" : 0,
			"vol_ambient" : 0,
			},
	}
}

var data = { }

func _ready():
	load_game()
#	update_text()

func load_game():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	data = parse_json(text)
	file.close()


func save_game():
	var file
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(data))
	file.close()


func reset_data():
	data = default_data.duplicate(true)


#func delete_data():
#	var dir = Directory.new()
#	dir.remove(path)
#	reset_data()
#	OS.shell_open(ProjectSettings.globalize_path("user://The_AD7/Saves"))
