extends Control

@onready var btn_wyjscie: Button = %Wyjscie

func _ready() -> void:
	if btn_wyjscie == null:
		push_error("Przycisk_Wyjscie not found! Check unique name.")
		return

	# ── AUTOMATIC FADE-IN ──
	# (only runs when arriving via transition from another scene)
	if Scene_TransitionController.is_transitioning:
		Scene_TransitionController.background.visible = true
		Scene_TransitionController.background.color = Color.BLACK
		
		Scene_TransitionController.animation_player.play("FadeIn")
		
		await Scene_TransitionController.animation_player.animation_finished
		
		Scene_TransitionController.background.visible = false
		Scene_TransitionController.is_transitioning = false
		
		print("Fade-in complete!")

	# Connect button AFTER fade-in logic
	# → prevents accidental clicks during the fade
	btn_wyjscie.pressed.connect(_on_wyjscie_pressed)

	# Optional – you can add more initialization here, e.g.:
	# btn_wyjscie.grab_focus()
	# ... other buttons, variables, etc. ...

func _on_wyjscie_pressed() -> void:
	# If you want smooth transition back → use the transition system
	# SceneTransitionController.fade_to_scene("res://scenes/main_menu.tscn", 0.8)
	
	# If you want instant change (as it was originally):
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
