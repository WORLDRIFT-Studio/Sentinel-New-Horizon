extends Popup

func _ready() -> void:
	GameEvents.menu_switched.connect(_menu_closed)
	
func _on_shop_pressed() -> void:
	GameEvents.menu_switched.emit(!get_tree().paused)
	self.show()
	
func _menu_closed(is_closed: bool) -> void:
	self.hide()
