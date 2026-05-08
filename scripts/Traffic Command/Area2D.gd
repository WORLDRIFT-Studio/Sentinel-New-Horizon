extends Area2D

signal clicked
signal crashed

var clickable: bool = false

func _ready() -> void:
	input_pickable = false
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(_other_area: Area2D) -> void:
	print("Kolizja!")
	emit_signal("crashed")

func enable_click() -> void:
	input_pickable = true
	clickable = true
	print("Można klikać!")

func _input_event(_viewport, event, _shape_idx) -> void:
	if not clickable:
		return
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked")
