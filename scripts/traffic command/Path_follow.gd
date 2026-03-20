extends PathFollow2D

@export var speed: float = 150.0
@export var stop_points: Array[float] = []

var moving: bool = true
var current_stop_index: int = 0

func _process(delta: float) -> void:
	if not moving:
		return
	
	progress += speed * delta
	_check_stop_points()

func _check_stop_points() -> void:
	if current_stop_index >= stop_points.size():
		return
	
	var next_stop = stop_points[current_stop_index]
	
	if progress_ratio >= next_stop:
		progress_ratio = next_stop
		moving = false
		current_stop_index += 1
		emit_signal("reached_stop_point", current_stop_index - 1)

signal reached_stop_point(index: int)

# Wywołaj to po wyborze gracza
func continue_moving() -> void:
	moving = true
