extends TextureButton

func _pressed() -> void:
	GameEvents.menu_switched.emit(true)
