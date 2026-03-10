extends Camera2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ScrollIn"):
		if get_zoom() < Vector2(1.5, 1.5):
			set_zoom(get_zoom() + Vector2(0.1, 0.1))
		return
		
	if event.is_action_pressed("ScrollOut"):
		if get_zoom() > Vector2(0.5, 0.5):
			set_zoom(get_zoom() - Vector2(0.1, 0.1))
		return

	
