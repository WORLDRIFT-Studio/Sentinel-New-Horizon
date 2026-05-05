extends Popup

var was_paused_by_me: bool = false

func open_popup(should_pause: bool):
	self.visible = true
	was_paused_by_me = should_pause # Zapamiętujemy decyzję
	
	if should_pause:
		get_tree().paused = true

func _on_close_pressed():
	print("Test")
	if was_paused_by_me:
		get_tree().paused = false
	self.visible = false
