extends Control

@onready var timer = $Timer
@onready var TimerLabel = $HBoxContainer/Panel/TimerLabel
@onready var VehicleNumberLabel = $HBoxContainer/Panel2/VehicleNumberLabel
@onready var score: Label = %Score
@onready var pr: Label = %PR

var time_left = 60
var vehicles_finished = 0
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready():
	TimerLabel.text = "Pozostały czas: " + str(time_left) + "s"
	VehicleNumberLabel.text = "Ukończone trasy: 0"
	timer.timeout.connect(_on_timer_timeout)
	owner.connect("crash", _on_crash)
	
	
func _on_crash() -> void:
	score.text = "Zdobyte punkty %s" % (vehicles_finished * 250)
	@warning_ignore("integer_division")
	pr.text = "Punkty reputacji %d" % (vehicles_finished * 250 / 1000)
	animation_player.play("PanelShowUp")
	
func _on_timer_timeout():
	time_left -= 1
	if time_left >= 0:
		TimerLabel.text = "Pozostały czas: " + str(time_left) + "s"
	else:
		timer.stop()
		TimerLabel.text = "Koniec czasu!"
		get_tree().paused = true

func add_finished_vehicle() -> void:
	vehicles_finished += 1
	VehicleNumberLabel.text = "Ukończone trasy: " + str(vehicles_finished)


func _on_continue_button_pressed() -> void:
	
	get_tree().paused = false
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")
