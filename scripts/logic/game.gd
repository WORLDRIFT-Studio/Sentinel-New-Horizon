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

var map_size: Vector2 

#endregion

func _ready() -> void:
	map_size = map.texture.get_size()
	GameEvents.connect("minigame_started", _on_minigame_started)
	GlobalData.restore_alerts(map)
	TimeManager.connect("alert", _spawn_alert)
	TimeManager.connect("day_ended", _delete_alerts)
	TimeManager.start_timer()

func _spawn_alert() -> void:
	var popup = popup_scene.instantiate()
	popup.position.x = randf_range(50, map_size.x - 50)
	popup.position.y = randf_range(50, map_size.y - 50)
	map.add_child(popup)
	NotificationManager.notify("Otrzymano nowe zgłoszenie !")

func _delete_alerts() -> void:
	var children: Array[Node] = get_tree().get_nodes_in_group("alert")
	for child in children:
		child.queue_free()
		
func _on_minigame_started() -> void:
	GlobalData.alerts_save(map)
	
