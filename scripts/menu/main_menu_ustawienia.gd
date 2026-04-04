extends Control

@onready var btn_wyjscie:      Button = %Wyjscie
@onready var btn_apply:      Button = %Apply
@onready var btn_back:      Button = %Back
@onready var btn_reset:      Button = %Reset

@onready var click_sound: AudioStreamPlayer = $ClickSound

func _ready() -> void:
	if btn_wyjscie == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  
		
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)

	if btn_apply == null:
		push_error("Przycisk_Apply not found! Check unique name.")
		return  
		
	btn_apply.pressed.connect(_on_apply_pressed)
	
	if btn_back == null:
		push_error("Przycisk_Back not found! Check unique name.")
		return  
		
	btn_back.pressed.connect(_on_back_pressed)
	
	if btn_reset == null:
		push_error("Przycisk_Reset not found! Check unique name.")
		return  
		
	btn_reset.pressed.connect(_on_reset_pressed)
		
	
func _on_wyjscie_pressed() -> void:
	click_sound.play()
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu.tscn")
	
	
func _on_apply_pressed() -> void:
	click_sound.play()

	
func _on_back_pressed() -> void:
	click_sound.play()

	
func _on_reset_pressed() -> void:
	click_sound.play()
