extends Control

@onready var btn_wyjscie:      Button = %Wyjscie


func _ready() -> void:
	if btn_wyjscie == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  
		
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)
	
func _on_wyjscie_pressed() -> void:
	
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu.tscn")
