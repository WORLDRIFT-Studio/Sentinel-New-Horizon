extends TextureProgressBar

@onready var slider: TextureRect = %TextureRect

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ActionButton"):
		var mouseX = get_local_mouse_position().x
		var percent = mouseX / size.x * 100
		self.value = percent
		slider.position.x = mouseX - slider.size.x / 2
