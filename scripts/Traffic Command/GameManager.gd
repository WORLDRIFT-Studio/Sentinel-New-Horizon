extends Node2D

@onready var k1_followers = [$Left/Right/PathFollow2D, $Left/Straight/PathFollow2D, $Left/Left/PathFollow2D]
@onready var k1_paths = [$Left/Right, $Left/Straight, $Left/Left]
@onready var k1_vehicle = $Left/Right/PathFollow2D/Node2D

@onready var k2_followers = [$Down/Right/PathFollow2D, $Down/Straight/PathFollow2D, $Down/Left/PathFollow2D]
@onready var k2_paths = [$Down/Right, $Down/Straight, $Down/Left]
@onready var k2_vehicle = $Down/Right/PathFollow2D/Node2D

@onready var k3_followers = [$Right/Right/PathFollow2D, $Right/Straight/PathFollow2D, $Right/Left/PathFollow2D]
@onready var k3_paths = [$Right/Right, $Right/Straight, $Right/Left]
@onready var k3_vehicle = $Right/Right/PathFollow2D/Node2D

@onready var k4_followers = [$Up/Right/PathFollow2D, $Up/Straight/PathFollow2D, $Up/Left/PathFollow2D]
@onready var k4_paths = [$Up/Right, $Up/Straight, $Up/Left]
@onready var k4_vehicle = $Up/Right/PathFollow2D/Node2D

var direction_timers: Array[float] = [10.0, 10.0, 10.0, 10.0]
var timer_limits: Array[float] = [10.0, 10.0, 10.0, 10.0]
var timer_active: Array[bool] = [false, false, false, false]

@onready var ui = $Menu

var directions: Array = []

func _process(delta: float) -> void:
	for i in range(directions.size()):
		if not timer_active[i]:
			continue
		var TimerLabel = directions[i]["vehicle"].get_node("Timer")
		direction_timers[i] -= delta
		TimerLabel.text = str(snapped(direction_timers[i], 0.01))
		
		if direction_timers[i] <= 5.0:
			var sprite = directions[i]["vehicle"].get_node("Sprite2D")
			sprite.modulate = Color(1, 0, 0)
		
		if direction_timers[i] <= 0:
			direction_timers[i] = 0
			timer_active[i] = false
			_force_continue(i)

func _force_continue(index: int) -> void:
	var d = directions[index]
	if d["active_follower"] == null:
		return
	
	var area = d["vehicle"].get_node("Area2D")
	area.clickable = false
	area.input_pickable = false
	
	var TimerLabel = d["vehicle"].get_node("Timer")
	TimerLabel.visible = false
	
	d["active_follower"].continue_moving()

func _ready() -> void:
	directions = [
		{ "followers": k1_followers, "paths": k1_paths, "vehicle": k1_vehicle, "active_index": -1, "active_follower": null },
		{ "followers": k2_followers, "paths": k2_paths, "vehicle": k2_vehicle, "active_index": -1, "active_follower": null },
		{ "followers": k3_followers, "paths": k3_paths, "vehicle": k3_vehicle, "active_index": -1, "active_follower": null },
		{ "followers": k4_followers, "paths": k4_paths, "vehicle": k4_vehicle, "active_index": -1, "active_follower": null },
	]
	
	for d in directions:
		var area = d["vehicle"].get_node("Area2D")
		area.crashed.connect(_on_crash)
	
	for i in range(directions.size()):
		_pick_random(i)

func _pick_random(index: int) -> void:
	var d = directions[index]
	
	if d["active_index"] != -1:
		d["paths"][d["active_index"]].hide_path()
		
		var old_follower = d["active_follower"]
		if old_follower.reached_stop.is_connected(func(): _on_reached_stop(index)):
			old_follower.reached_stop.disconnect(func(): _on_reached_stop(index))
		if old_follower.route_finished.is_connected(func(): _pick_random(index)):
			old_follower.route_finished.disconnect(func(): _pick_random(index))
		
		var old_area = d["vehicle"].get_node("Area2D")
		if old_area.clicked.is_connected(func(): _on_vehicle_clicked(index)):
			old_area.clicked.disconnect(func(): _on_vehicle_clicked(index))
	
	var new_index = d["active_index"]
	while new_index == d["active_index"]:
		new_index = randi() % 3
	
	d["active_index"] = new_index
	d["active_follower"] = d["followers"][d["active_index"]]
	
	var vehicle = d["vehicle"]
	vehicle.reparent(d["active_follower"], false)
	vehicle.position = Vector2.ZERO
	
	d["paths"][d["active_index"]].show_path()
	d["active_follower"].reset()
	d["active_follower"].reached_stop.connect(func(): _on_reached_stop(index))
	d["active_follower"].route_finished.connect(func(): _on_route_finished(index))
	
	print("Kierunek ", index + 1, " — wylosowano trasę: ", new_index + 1)

func _on_reached_stop(index: int) -> void:
	var d = directions[index]
	var area = d["vehicle"].get_node("Area2D")
	
	area.enable_click()
	direction_timers[index] = timer_limits[index]
	timer_active[index] = true
	
	var TimerLabel = d["vehicle"].get_node("Timer")
	TimerLabel.visible = true
	
	if not area.clicked.is_connected(func(): _on_vehicle_clicked(index)):
		area.clicked.connect(func(): _on_vehicle_clicked(index))

func _on_vehicle_clicked(index: int) -> void:
	var sprite = directions[index]["vehicle"].get_node("Sprite2D")
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	timer_active[index] = false
	direction_timers[index] = timer_limits[index]
	
	var TimerLabel = directions[index]["vehicle"].get_node("Timer")
	TimerLabel.visible = false
	
	directions[index]["active_follower"].continue_moving()

func _on_route_finished(index: int) -> void:
	var sprite = directions[index]["vehicle"].get_node("Sprite2D")
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	ui.add_finished_vehicle()
	_pick_random(index)

func _on_crash() -> void:
	print("Kolizja — koniec gry!")
	get_tree().paused = true
