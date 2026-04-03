extends PathFollow2D

@export var speed: float = 150.0
@export var stop_points: Array[float] = []

var moving: bool = false
var current_stop_index: int = 0
var last_progress: float = 0.0

signal reached_stop
signal route_finished

func _ready() -> void:
	moving = true

func _process(delta: float) -> void:
	if not moving:
		return
	
	progress += speed * delta
	
	if progress_ratio < last_progress - 0.5:
		current_stop_index = 0
		emit_signal("route_finished")
	
	last_progress = progress_ratio
	
	if current_stop_index >= stop_points.size():
		return
	
	var next_stop = stop_points[current_stop_index]
	
	if progress_ratio >= next_stop:
		progress_ratio = next_stop
		moving = false
		current_stop_index += 1
		emit_signal("reached_stop")

func continue_moving() -> void:
	moving = true

func reset() -> void:
	progress = 0.0
	progress_ratio = 0.0
	current_stop_index = 0
	last_progress = 0.0
	moving = true
