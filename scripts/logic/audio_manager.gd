extends Node

var click_player: AudioStreamPlayer

func _ready() -> void:
	click_player = AudioStreamPlayer.new()
	click_player.bus = "SFX"
	add_child(click_player)
	var sound = load("res://assets/sounds/button.mp3")
	if sound:
		click_player.stream = sound
	register_buttons(get_tree().root)
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if node is Button or node is TextureButton:
		_connect_button(node)


func register_buttons(node: Node) -> void:
	for child in node.get_children():
		if child is Button or child is TextureButton:
			_connect_button(child)
		register_buttons(child)

		
func _connect_button(btn) -> void:
	if not btn.button_down.is_connected(_play_click):
		btn.button_down.connect(_play_click)

				
func _play_click() -> void:
	if click_player:
		click_player.stop() 
		click_player.play()
