extends Node2D

@onready var follower_1 = $Path2D_1/PathFollow2D
@onready var follower_2 = $Path2D_2/PathFollow2D
@onready var follower_3 = $Path2D_3/PathFollow2D

@onready var node_1 = $Path2D_1/PathFollow2D/Node2D
@onready var node_2 = $Path2D_2/PathFollow2D/Node2D
@onready var node_3 = $Path2D_3/PathFollow2D/Node2D

@onready var area_1 = $Path2D_1/PathFollow2D/Node2D/Area2D
@onready var area_2 = $Path2D_2/PathFollow2D/Node2D/Area2D
@onready var area_3 = $Path2D_3/PathFollow2D/Node2D/Area2D

var active_follower: PathFollow2D = null
var active_area: Area2D = null

func _ready() -> void:
	node_1.visible = false
	node_2.visible = false
	node_3.visible = false

	var all_nodes = [node_1, node_2, node_3]
	var all_followers = [follower_1, follower_2, follower_3]
	var all_areas = [area_1, area_2, area_3]

	var index = randi() % 3
	active_follower = all_followers[index]
	active_area = all_areas[index]
	all_nodes[index].visible = true

	print("Wylosowano pojazd: ", index + 1)

	active_follower.reached_stop.connect(_on_reached_stop)

func _on_reached_stop() -> void:
	print("Pojazd dojechał — odblokowano klikanie")
	active_area.enable_click()
	
	if not active_area.clicked.is_connected(_on_vehicle_clicked):
		active_area.clicked.connect(_on_vehicle_clicked)

func _on_vehicle_clicked() -> void:
	active_follower.continue_moving()
