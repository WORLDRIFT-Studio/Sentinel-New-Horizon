extends Control

@onready var btn_wyjscie:      Button = %Wyjscie
@onready var btn_next:      Button = %Next

@onready var click_sound: AudioStreamPlayer = $ClickSound

func _ready() -> void:
	if btn_wyjscie == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  
		
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)
	
	if btn_next == null:
		push_error("Przycisk_Next not found! Check unique name.")
		return  
		
	btn_next.pressed.connect(_on_next_pressed)

func _on_wyjscie_pressed() -> void:
	
	AtTransitionScene.fade_to_scene("res://scenes/menu/main_menu.tscn")

func _on_next_pressed() -> void:
	
	AtTransitionScene.fade_to_scene("res://scenes/menu/autorzy_side_menu.tscn")
