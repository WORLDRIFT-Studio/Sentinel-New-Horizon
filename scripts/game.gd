extends Node2D

func _ready() -> void:
	GameEvents.menu_opened.connect(_menu_opened)
	GameEvents.menu_closed.connect(_menu_closed)
	
func _menu_opened() -> void:
	get_tree().paused = true
	
func _menu_closed() -> void:
	get_tree().paused = false
