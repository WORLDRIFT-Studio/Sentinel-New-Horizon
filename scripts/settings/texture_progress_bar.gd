# Wykorzystano pomoc ChatGPT

extends TextureProgressBar

@onready var slider: TextureRect = %TextureRect
var dragging: bool = false


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ActionButton"):
		dragging = event.is_pressed()
		update_bar(event.position.x)
	elif event is InputEventMouseButton and not event.is_pressed():
		dragging = false
	elif event is InputEventMouseMotion and dragging:
		update_bar(event.position.x)


func update_bar(mouse_position_x:float):
	var percent = mouse_position_x / size.x * 100
	self.value = percent
	slider.position.x = clamp((mouse_position_x - slider.size.x / 2), 0, 650)
	
