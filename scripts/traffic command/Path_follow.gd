extends PathFollow2D

@export var speed: float = 150.0
@export var stop_ratio: float = 0.25

var moving: bool = false

signal reached_stop

func _ready() -> void:
	moving = true

func _process(delta: float) -> void:
	if not moving:
		return
	progress += speed * delta
	
	if progress_ratio >= stop_ratio:
		progress_ratio = stop_ratio
		moving = false
		emit_signal("reached_stop")

func continue_moving() -> void:
	moving = true
