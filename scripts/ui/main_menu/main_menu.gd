extends Control
	
@onready var btn_nowa_gra:     Button = %NowaGra
@onready var btn_kontynuuj:    Button = %Kontynuuj
@onready var btn_ustawienia:   Button = %Ustawienia
@onready var btn_autorzy:      Button = %Autorzy
@onready var btn_wyjscie:      Button = %Wyjscie



func _input(event):
	if event is InputEventMouseButton:
		print("klik globalny")
		
func _ready() -> void:
	btn_nowa_gra.pressed.connect(_on_nowa_gra_pressed)
	btn_kontynuuj.pressed.connect(_on_kontynuuj_pressed)
	#btn_ustawienia.pressed.connect(_on_ustawienia_pressed)
	#btn_autorzy.pressed.connect(_on_autorzy_pressed)
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)
	
	btn_kontynuuj.disabled = not FileAccess.file_exists(SaveLoad.SAVE_LOCATION)
	
	%NowaGra.grab_focus()


func _on_nowa_gra_pressed() -> void:
	SaveLoad._reset()
	SaveLoad.save_content()
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")

func _on_kontynuuj_pressed() -> void:
	SaveLoad.load_content()
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")


#func _on_autorzy_pressed() -> void:
	#TransitionScene.fade_to_scene("res://scenes/menu/main_menu_autorzy.tscn")

func _on_wyjscie_pressed() -> void:
	get_tree().quit()
