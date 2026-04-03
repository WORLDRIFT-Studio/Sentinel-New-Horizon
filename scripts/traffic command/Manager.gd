extends Node2D

@onready var follower_1 = $Path2D_1/PathFollow2D
@onready var follower_2 = $Path2D_2/PathFollow2D
@onready var follower_3 = $Path2D_3/PathFollow2D

@onready var vehicle_node = $Path2D_1/PathFollow2D/Node2D
@onready var vehicle_area = $Path2D_1/PathFollow2D/Node2D/Area2D

@onready var path_1 = $Path2D_1
@onready var path_2 = $Path2D_2
@onready var path_3 = $Path2D_3

var all_followers: Array
var all_paths: Array

var active_index: int = -1
var active_follower: PathFollow2D = null

func _ready() -> void:
	all_followers = [follower_1, follower_2, follower_3]
	all_paths = [path_1, path_2, path_3]
	
	vehicle_area.crashed.connect(_on_crash)
	
	_pick_random()

func _pick_random() -> void:
	if active_index != -1:
		all_paths[active_index].hide_path()
	
		if active_follower.reached_stop.is_connected(_on_reached_stop):
			active_follower.reached_stop.disconnect(_on_reached_stop)
		if active_follower.route_finished.is_connected(_on_route_finished):
			active_follower.route_finished.disconnect(_on_route_finished)
		if vehicle_area.clicked.is_connected(_on_vehicle_clicked):
			vehicle_area.clicked.disconnect(_on_vehicle_clicked) 
	
	var new_index = active_index
	while new_index == active_index:
		new_index = randi() % 3
	
	active_index = new_index
	active_follower = all_followers[active_index]
	
	vehicle_node.reparent(active_follower, false)
	
	all_paths[active_index].show_path()
	
	active_follower.reset()
	active_follower.reached_stop.connect(_on_reached_stop)
	active_follower.route_finished.connect(_on_route_finished)
	
	print("Wylosowano ścieżkę: ", active_index + 1)

func _on_reached_stop() -> void:
	vehicle_area.enable_click()
	if not vehicle_area.clicked.is_connected(_on_vehicle_clicked):
		vehicle_area.clicked.connect(_on_vehicle_clicked)

func _on_vehicle_clicked() -> void:
	active_follower.continue_moving()

func _on_route_finished() -> void:
	_pick_random()

func _on_crash() -> void:
	print("Kolizja - koniec gry!")
	get_tree().paused = true
	#get_tree().change_scene_to_file()
