#Użyto pomocy Claude
extends Node2D

@export var car_scene: PackedScene

const D_LANES =  [1080.0, 1245.0]
const U_LANES = [725.0, 890.0]
var base_interval = 3.0
var min_interval = 0.4
var difficulty_timer = 0.0
var car_speed = 200.0

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
	
	var u_car = car_scene.instantiate()
	var d_car = car_scene.instantiate()
	
	var u_lane = U_LANES[randi() % U_LANES.size()]
	u_car.position.x = u_lane
	u_car.position.y = -565.0
	u_car.rotation_degrees = -90.0
	u_car.speed = 2.5 * car_speed
	
	var d_lane = D_LANES[randi() % D_LANES.size()]
	d_car.position.x = d_lane
	d_car.position.y = 542.0
	d_car.speed = -car_speed
	
	get_parent().add_child(u_car)
	get_parent().add_child(d_car)
