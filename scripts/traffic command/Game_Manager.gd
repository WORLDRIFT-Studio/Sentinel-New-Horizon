extends Node2D

var selected_vehicle: PathFollow2D = null

func _ready() -> void:
	for path in get_tree().get_nodes_in_group("vehicles"):
		path.vehicle_clicked.connect(_on_vehicle_clicked)

func _on_vehicle_clicked(follower: PathFollow2D) -> void:
	selected_vehicle = follower
	selected_vehicle.continue_moving()
