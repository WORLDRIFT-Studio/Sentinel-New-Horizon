extends Node2D

func _ready():
	await get_tree().create_timer(4.0).timeout
	TransitionScene.fade_to_scene("res://loading.tscn")
