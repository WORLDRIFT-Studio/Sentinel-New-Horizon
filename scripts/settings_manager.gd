extends Node
	
func _set_setting(option:String, value):
	match option:
		"Fullscreeen":
			if value == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		"V-Sync":
			if value == true:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		"Audio":
			audio(value)

func audio(value):
	var bus_id = AudioServer.get_bus_index(value["bus"])
	var db = linear_to_db(value["value"])
	AudioServer.set_bus_volume_db(bus_id, db)
