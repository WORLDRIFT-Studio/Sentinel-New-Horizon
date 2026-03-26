extends Control
	
@onready var btn_nowa_gra:     Button = %NowaGra
@onready var btn_kontynuuj:    Button = %Kontynuuj
@onready var btn_ustawienia:   Button = %Ustawienia
@onready var btn_autorzy:      Button = %Autorzy
@onready var btn_wyjscie:      Button = %Wyjscie

func _ready() -> void:
	if btn_nowa_gra == null:
		push_error("Przycisk_NowaGra not found! Check unique name.")
		return  
	if btn_kontynuuj== null:
		push_error("Przycisk_Kontynuuj not found! Check unique name.")
		return  
	if btn_ustawienia== null:
		push_error("Przycisk_Ustawienia not found! Check unique name.")
		return  
	if btn_autorzy== null:
		push_error("Przycisk_Autorzy not found! Check unique name.")
		return  
	if btn_wyjscie== null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return  

	btn_nowa_gra.pressed.connect(_on_nowa_gra_pressed)
	btn_kontynuuj.pressed.connect(_on_kontynuuj_pressed)
	btn_ustawienia.pressed.connect(_on_ustawienia_pressed)
	btn_autorzy.pressed.connect(_on_autorzy_pressed)
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)

	%NowaGra.grab_focus() 

func _on_nowa_gra_pressed() -> void:
	$Scene_TransitionController.fade_to_scene("res://scenes/main_menu_nowa_gra.tscn", 0.8)
	
func _on_kontynuuj_pressed() -> void:
	$TransitionController.fade_to_scene("res://scenes/main_menu_kontynuuj.tscn", 0.8)

func _on_ustawienia_pressed() -> void:
	$TransitionController.fade_to_scene("res://scenes/main_menu_ustawienia.tscn", 0.8)
	
func _on_autorzy_pressed() -> void:
	$TransitionController.fade_to_scene("res://scenes/main_menu_autorzy.tscn", 0.8)
	
func _on_wyjscie_pressed() -> void:
	get_tree().quit()
