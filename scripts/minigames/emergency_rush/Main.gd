extends Node2D

var score = 0.0

@onready var score_label = $UI/ScoreLabel
@onready var ambulance = $Ambulance
@onready var spawner = $Spawner

func _process(delta):
	score += delta * 10
	score_label.text = "Punkty: " + str(int(score))

func on_ambulance_hit():
	get_tree().paused = true
