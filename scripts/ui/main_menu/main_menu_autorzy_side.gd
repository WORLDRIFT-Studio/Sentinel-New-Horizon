extends Control

@onready var btn_wyjscie:      Button = %Wyjscie
@onready var btn_back:      Button = %Back


func _ready() -> void:
	if btn_wyjscie == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  
		
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)
	
	if btn_back == null:
		push_error("Przycisk_Back not found! Check unique name.")
		return  
		
	btn_back.pressed.connect(_on_back_pressed)
	
func _on_wyjscie_pressed() -> void:
	
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu.tscn")

func _on_back_pressed() -> void:
	
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu_autorzy.tscn")
