extends Popup

func _ready() -> void:
	GameEvents.menu_closed.connect(_menu_closed)
		
func _on_settings_pressed() -> void:
	GameEvents.menu_opened.emit()
	self.show()
	
func _menu_closed() -> void:
	self.hide()
