extends Tabs

func _ready():
	print(OS.get_name(), ", ",
	OS.get_locale(), ", ",
	Time.get_datetime_string_from_system(), ", ",
	OS.get_processor_count(), ", ",
	OS.get_real_window_size(), ", ",
	OS.get_screen_count(), ", ",
	OS.get_screen_size(), ", ",
	OS.get_screen_refresh_rate())
