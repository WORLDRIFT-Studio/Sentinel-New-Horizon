extends Node

var click_player: AudioStreamPlayer	


func _enter_tree() -> void:
	var tree = get_tree().root
	print("============================================================")
	print("                       Łącze guziki:                        ")
	print("============================================================")
	_register_node(tree)
	print("============================================================")
	print("                    Łączenie zakończone                     ")
	print("============================================================")
	
func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	process_mode = Node.PROCESS_MODE_ALWAYS

	var click_sound = preload("res://assets/sounds/button.mp3")	
	click_player = AudioStreamPlayer.new()
	click_player.bus = "SFX"
	click_player.stream = click_sound
	add_child(click_player)	

func _on_node_added(node: Node) -> void:
	_check_button(node)
	
func _register_node(tree: Node) -> void:
	for node in tree.get_children():
		_check_button(node)
		_register_node(node)
				
func _check_button(node) -> void:
	if node is Button or node is TextureButton:
		if not node.button_down.is_connected(_play_sound):
			node.button_down.connect(_play_sound)
			print(node.name, " connected")
				
func _play_sound() -> void:
	click_player.stop()
	click_player.play()
	pass
