extends Control

@onready var btn_autorzy:      Button = %Autorzy

func _ready() -> void:
	if btn_autorzy == null:
		push_error("Autorzy not found! Check unique name.")
		return  
		
	btn_autorzy.pressed.connect(_on_autorzy_pressed)
	
func _on_wyjscie_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_autorzy.tscn")
