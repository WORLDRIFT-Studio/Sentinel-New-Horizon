extends Button

func _on_pressed() -> void:
	GameEvents.menu_closed.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_close_dialog"):
		GameEvents.menu_closed.emit()
		
