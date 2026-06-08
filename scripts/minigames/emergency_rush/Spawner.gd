#Użyto pomocy Claude
extends Node2D

@export var car_scene: PackedScene
@export var fuel_scene: PackedScene

const R_LANES =  [1080.0, 1245.0]
const L_LANES = [725.0, 890.0]
const LANES = L_LANES + R_LANES
var base_interval = 3.0
var min_interval = 0.4
var difficulty_timer = 0.0
var car_speed = 200.0
var fuel_timer = 5.0

@onready var car_spawn_timer = $CarSpawnTimer
@onready var fuel_spawn_timer = $FuelSpawnTimer

func _ready():
	car_spawn_timer.wait_time = base_interval
	fuel_spawn_timer.wait_time = fuel_timer
	car_spawn_timer.start()
	fuel_spawn_timer.start()
	car_spawn_timer.timeout.connect(_on_car_spawn_timer_timeout)
	fuel_spawn_timer.timeout.connect(_on_fuel_spawn_timer_timeout)

func _process(delta):
	difficulty_timer += delta
	
	if difficulty_timer >= 10.0:
		difficulty_timer = 0.0
		base_interval = max(min_interval, base_interval - 0.15)
		car_speed = min(800.0, car_speed + 30.0)
		car_spawn_timer.wait_time = base_interval

func _on_car_spawn_timer_timeout():
	if car_scene == null:
		return
	
	var l_car = car_scene.instantiate()
	var r_car = car_scene.instantiate()
	
	var l_lane = L_LANES[randi() % L_LANES.size()]
	l_car.position.x = l_lane
	l_car.position.y = -710.0
	l_car.rotation_degrees = -90.0
	l_car.speed = 2 * car_speed
	l_car.get_node("Sprite2D").frame = randi() % 3
	
	var r_lane = R_LANES[randi() % R_LANES.size()]
	r_car.position.x = r_lane
	r_car.position.y = -710.0
	r_car.speed = car_speed
	r_car.get_node("Sprite2D").frame = randi() % 3
	
	get_parent().add_child(l_car)
	get_parent().add_child(r_car)

func _on_fuel_spawn_timer_timeout():
	if fuel_scene == null:
		return
	var fuel = fuel_scene.instantiate()
	var lane = LANES[randi() % LANES.size()]
	
	fuel.position.x = lane
	fuel.position.y = -710.0
	
	get_parent().add_child(fuel)
