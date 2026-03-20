extends Area2D

signal vehicle_clicked(follower: PathFollow2D)

func _ready() -> void:
	input_pickable = true

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("vehicle_clicked", get_parent())
