extends Area2D

signal clicked

var clickable: bool = false

func _ready() -> void:
	input_pickable = false

func enable_click() -> void:
	input_pickable = true
	clickable = true
	print("Można klikać!")

func _input_event(_viewport, event, _shape_idx) -> void:
	if not clickable:
		return
	if event is InputEventMouseButton and event.pressed:
		print("Kliknięto!")
		emit_signal("clicked")
