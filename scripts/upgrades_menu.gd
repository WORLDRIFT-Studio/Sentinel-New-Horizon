extends Popup

func _ready() -> void:
	GameEvents.menu_closed.connect(_menu_closed)
	
func _on_shop_pressed() -> void:
	GameEvents.menu_opened.emit(!get_tree().paused)
	self.show()
	
func _menu_closed(is_closed: bool) -> void:
	self.hide()
