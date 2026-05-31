extends Node2D

var score = 0.0
var lives = 3
var game_over = false

@onready var score_label = $UI/ScoreLabel
@onready var lives_label = $UI/LivesLabel
@onready var game_over_panel = $UI/GameOverPanel
@onready var ambulance = $Ambulance
@onready var spawner = $Spawner

func _ready():
	game_over_panel.visible = false
	update_ui()

func _process(delta):
	if game_over:
		return
	
	score += delta * 10
	score_label.text = "Punkty: " + str(int(score))

func on_ambulance_hit():
	if game_over:
		return
	
	lives -= 1
	update_ui()
	
	if lives <= 0:
		_trigger_game_over()
	else:
		ambulance.position.x = 240.0

func _trigger_game_over():
	game_over = true
	game_over_panel.visible = true
	spawner.get_node("SpawnTimer").stop()
	$UI/GameOverPanel/GameOverLabel.text = "Koniec!\nPunkty: " + str(int(score))

func update_ui():
	lives_label.text = "Życia: " + str(lives)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
