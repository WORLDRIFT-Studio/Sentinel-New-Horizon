extends Node

var click_player: AudioStreamPlayer

func _ready() -> void:
	# 1. Przygotowanie odtwarzacza
	click_player = AudioStreamPlayer.new()
	add_child(click_player)
	click_player.stream = load("res://assets/sounds/button.mp3")
	
	# 2. PODPIĘCIE POD ISTNIEJĄCE PRZYCISKI
	# Przeszukujemy to, co już zdążyło się załadować na starcie
	register_buttons(get_tree().root)
	
	# 3. NASŁUCHIWANIE NA NOWE PRZYCISKI
	# To zajmie się przyciskami dodawanymi w trakcie gry
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		_connect_button(node)

# Funkcja pomocnicza do przeszukiwania drzewa (rekurencja)
func register_buttons(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			_connect_button(child)
		register_buttons(child)

# Funkcja spinająca sygnał z dźwiękiem
func _connect_button(btn: Button) -> void:
	# Zapobiegamy podwójnemu podpięciu (na wszelki wypadek)
	if not btn.pressed.is_connected(_play_click):
		btn.pressed.connect(_play_click)

func _play_click() -> void:
	click_player.play()
