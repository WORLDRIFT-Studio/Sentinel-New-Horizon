extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
signal show_alert

func _ready() -> void:
	animation_player.play("alert")



func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			show_alert.emit()
