extends Control

@onready var btn_kontunuuj:      Button = %Kontynuuj

func _ready() -> void:
	if btn_kontunuuj == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  
		
		
	btn_kontunuuj.pressed.connect(_on_kontynuuj_pressed)
	
func _on_wyjscie_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
