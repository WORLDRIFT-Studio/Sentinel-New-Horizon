extends Node

var click_player: AudioStreamPlayer

func _ready() -> void:
	click_player = AudioStreamPlayer.new()
	add_child(click_player)
	click_player.stream = load("res://assets/sounds/button.mp3")
	
	register_buttons(get_tree().root)
	
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		_connect_button(node)

func register_buttons(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			_connect_button(child)
		register_buttons(child)

func _connect_button(btn: Button) -> void:
	if not btn.pressed.is_connected(_play_click):
		btn.pressed.connect(_play_click)

func _play_click() -> void:
	click_player.play()
