extends PathFollow2D

@export var speed: float = 150.0
@export var stop_points: Array[float] = []

@export var vehicle_textures: Array[Texture2D] = [
	load("res://assets/assets/Traffic Command/car1.png"),
	load("res://assets/assets/Traffic Command/car2.png"),
	load("res://assets/assets/Traffic Command/car3.png")
]
@export var vehicle_speeds: Array[float] = [80.0, 100.0, 120.0, 150.0, 180.0]

var moving: bool = false
var current_stop_index: int = 0
var last_progress: float = 0.0

signal reached_stop
signal route_finished

func _ready() -> void:
	moving = true
	_randomize_vehicle()

func _randomize_vehicle() -> void:
	if not vehicle_speeds.is_empty():
		speed = vehicle_speeds.pick_random()
	
	if not vehicle_textures.is_empty():
		var node2d = get_node_or_null("Node2D")
		if node2d == null:
			return
		var sprite = node2d.get_node_or_null("Sprite2D")
		if sprite == null:
			return
		sprite.texture = vehicle_textures.pick_random()

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
	_randomize_vehicle()
