extends Control
	
@onready var btn_nowa_gra:     Button = %NowaGra
@onready var btn_kontynuuj:    Button = %Kontynuuj
@onready var btn_ustawienia:   Button = %Ustawienia
@onready var btn_autorzy:      Button = %Autorzy
@onready var btn_wyjscie:      Button = %Wyjscie

@onready var click_sound: AudioStreamPlayer = $ClickSound


func _input(event):
	if event is InputEventMouseButton:
		print("klik globalny")
		
func _ready() -> void:
	btn_nowa_gra.pressed.connect(_on_nowa_gra_pressed)
	btn_kontynuuj.pressed.connect(_on_kontynuuj_pressed)
	btn_ustawienia.pressed.connect(_on_ustawienia_pressed)
	btn_autorzy.pressed.connect(_on_autorzy_pressed)
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)

	%NowaGra.grab_focus()


func _on_nowa_gra_pressed() -> void:
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu_nowa_gra.tscn")

func _on_kontynuuj_pressed() -> void:
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu_kontynuuj.tscn")

func _on_ustawienia_pressed() -> void:
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu_ustawienia.tscn")

func _on_autorzy_pressed() -> void:
	TransitionScene.fade_to_scene("res://scenes/menu/main_menu_autorzy.tscn")

func _on_wyjscie_pressed() -> void:
	get_tree().quit()
