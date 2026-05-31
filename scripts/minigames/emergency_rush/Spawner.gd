extends Node2D

@export var car_scene: PackedScene

const LANES = [740.0, 890.0, 1030.0, 1160.0]
var base_interval = 2.0
var min_interval = 0.4
var difficulty_timer = 0.0
var car_speed = 400.0

@onready var spawn_timer = $SpawnTimer

func _ready():
	spawn_timer.wait_time = base_interval
	spawn_timer.start()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _process(delta):
	difficulty_timer += delta
	
	if difficulty_timer >= 10.0:
		difficulty_timer = 0.0
		base_interval = max(min_interval, base_interval - 0.15)
		car_speed = min(800.0, car_speed + 30.0)
		spawn_timer.wait_time = base_interval

func _on_spawn_timer_timeout():
	if car_scene == null:
		return
	
	var car = car_scene.instantiate()
	
	var lane = LANES[randi() % LANES.size()]
	car.position.x = lane
	car.position.y = -60.0
	car.speed = car_speed
	
	get_parent().add_child(car)
