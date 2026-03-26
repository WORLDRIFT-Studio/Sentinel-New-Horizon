extends CanvasLayer

signal transitioned

func transition():
	$AnimationPlayer.play("FadeOut")
	print("Fading to black")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		print("Emit signal transitioned")
		emit_signal("transitioned")
		$AnimationPlayer.play("FadeIn")
	if anim_name == "FadeIn":
		print("Finished fading")
