extends Control

@onready var btn_nowa_gra:     Button = %Przycisk_NowaGra
@onready var btn_kontynuuj:    Button = %Przycisk_Kontynuuj
@onready var btn_ustawienia:   Button = %Przycisk_Ustawienia
@onready var btn_autorzy:      Button = %Przycisk_Autorzy
@onready var btn_wyjscie:      Button = %Przycisk_Wyjscie

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

	%Przycisk_NowaGra.grab_focus() 

func _on_nowa_gra_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_nowa_gra.tscn")
	
func _on_kontynuuj_pressed() -> void:
	get_tree().change_scene_to_file	("res://scenes/main_menu_kontynuuj.tscn")

func _on_ustawienia_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_ustawienia.tscn")
	
func _on_autorzy_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_autorzy.tscn")
	
func _on_wyjscie_pressed() -> void:
	get_tree().quit()
