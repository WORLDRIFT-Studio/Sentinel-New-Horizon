extends Node2D

#region Export

@export_category("Alerts")
@export var popup_scene: PackedScene
@export_group("Alerts Limits")
@export_range(0, 20, 1, "prefer_slider") var minimum_alerts: int = 5
@export_range(0, 20, 1, "prefer_slider") var maximum_alerts: int = 10

#endregion

#region Variable

@onready var map: Sprite2D = %Map
@onready var hud: CanvasLayer = %HUD

var alerts_number: int
var map_size: Vector2 

#endregion

func _ready() -> void:
	alerts_number = randi_range(minimum_alerts, maximum_alerts)
	map_size = map.texture.get_size()

func spawn_alert() -> void:
	var popup = popup_scene.instantiate()
	popup.position.x = randf_range(50, map_size.x - 50)
	popup.position.y = randf_range(50, map_size.y - 50)
	map.add_child(popup)
