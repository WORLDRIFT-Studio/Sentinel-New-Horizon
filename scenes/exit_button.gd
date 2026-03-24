extends TextureButton

func _pressed() -> void:
	GameEvents.menu_closed.emit(false)
