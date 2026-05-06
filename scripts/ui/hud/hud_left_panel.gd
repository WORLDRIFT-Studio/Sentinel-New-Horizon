extends Popup

@onready var panel: Panel = %Panel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var invisible_background: PanelContainer = %InvisibleBackground


func open_popup():
	self.show()
	animation_player.play("LeftPanel")
	

func _on_invisible_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			animation_player.play_backwards("LeftPanel")
			await animation_player.animation_finished
			self.hide()
