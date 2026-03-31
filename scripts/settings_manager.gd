extends Node
	
func _set_setting(option:String, value):
	option = option.to_lower()
	match option:
		"fullscreeen":
			if value == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			print("Fullscreen")
		"v-sync":
			if value == true:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			print("Vsync")
