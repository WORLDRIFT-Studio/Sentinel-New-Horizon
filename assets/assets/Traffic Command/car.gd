extends Node2D

@onready var timer_label = $Timer
@onready var sprite = $Sprite2D
@onready var area = $Area2D

func update_timer(value: float):
	timer_label.text = str(snapped(value, 0.1))
	if value <= 5.0:
		sprite.modulate = Color(1, 0, 0) # Robi się czerwony, gdy czas ucieka

func set_normal_color():
	sprite.modulate = Color(1, 1, 1)
