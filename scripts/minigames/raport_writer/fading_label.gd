extends Label

func _ready():
	show_fading_message("KEYBINDS: Q, W, E, R", 3.0)

func show_fading_message(message_text: String, display_time: float):
	text = message_text
	modulate.a = 1.0
	show()
	
	var tween = create_tween()
	tween.tween_interval(display_time)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(hide)


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.
