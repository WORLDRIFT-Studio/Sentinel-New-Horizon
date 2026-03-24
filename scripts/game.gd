extends Node2D

func _ready() -> void:
	GameEvents.menu_opened.connect(_menu_opened)
	GameEvents.menu_closed.connect(_menu_closed)
	
func _menu_opened(is_open:bool) -> void:
	get_tree().paused = is_open
	
func _menu_closed(is_open: bool) -> void:
	get_tree().paused = is_open
