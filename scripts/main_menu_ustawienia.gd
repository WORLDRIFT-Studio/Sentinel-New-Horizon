extends Control

@onready var btn_wyjscie:      Button = %Przycisk_Wyjscie

func _ready() -> void:
	if btn_wyjscie == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  
		
		
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)
	
func _on_wyjscie_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
