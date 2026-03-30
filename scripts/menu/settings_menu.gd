extends Popup

func _ready() -> void:
	GameEvents.menu_closed.connect(_menu_closed)
	GameEvents.checkbox_marked.connect(_settings)
		
func _on_settings_pressed() -> void:
	GameEvents.menu_opened.emit()
	self.show()
	
func _menu_closed() -> void:
	self.hide()

func _settings(setting:String, value:bool) -> void:
	match setting:
		"fullscreen":
			if value == true:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
