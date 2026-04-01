extends AudioStreamPlayer

func _ready() -> void:
	GameEvents.music_val_changed.connect(_on_music_val_changed)
	
func _on_music_val_changed(bus:String, value:float):
	if bus == "Music":
		self.
AudioServer.
