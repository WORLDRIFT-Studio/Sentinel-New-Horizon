extends TextureButton

func _on_pressed() -> void:
	GameEvents.menu_closed.emit()
