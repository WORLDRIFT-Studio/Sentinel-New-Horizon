extends Control

@export var pause: bool

func _ready() -> void:
	GameEvents.menu_closed.connect(_menu_closed)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			get_child(0).open_popup(pause)
			get_tree().paused = true
			
func _menu_closed() -> void:
	get_child(0).visible = false
	get_tree().paused = false
