extends Popup

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var was_paused_by_me: bool = false

func open_popup(should_pause: bool):
	self.show()
	animation_player.play("Panels/PanelShow")	
	was_paused_by_me = should_pause # Zapamiętujemy decyzję
	if should_pause:
		get_tree().paused = true

func _on_close_pressed():
	if was_paused_by_me:
		get_tree().paused = false
	animation_player.play_backwards("Panels/PanelShow")
	await animation_player.animation_finished
	self.hide()
