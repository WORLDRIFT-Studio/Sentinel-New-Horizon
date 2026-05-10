extends CanvasLayer

@export var notify_tscn: PackedScene
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var notification_conatiner: VBoxContainer = $NotificationConatiner
	
func notify(message:String) -> void: # Generator powiadomień
	var popup = notify_tscn.instantiate() 
	popup.setup(message)
	audio_stream_player.play()
	notification_conatiner.add_child(popup)
	print("Powiadomienie:", message)
