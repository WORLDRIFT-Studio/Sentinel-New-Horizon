extends Control

@onready var timer = %Timer
@onready var TimerLabel = %TimerLabel
@onready var VehicleNumberLabel = %VehicleNumberLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var time: Label = %Time
@onready var cars: Label = %Cars
@onready var score_label: Label = %Score

var start_time = 60
var time_left = 60
var vehicles_finished = 0
var score = 0
var displayed: bool = false

func _ready():
	owner.connect("crash", _display_summary)
	TimerLabel.text = "Pozostały czas: " + str(time_left) + "s"
	VehicleNumberLabel.text = "Ukończone trasy: 0"
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	time_left -= 1
	if time_left >= 0:
		TimerLabel.text = "Pozostały czas: " + str(time_left) + "s"
	else:
		timer.stop()
		TimerLabel.text = "Koniec czasu!"
		_display_summary()

func add_finished_vehicle() -> void:
	vehicles_finished += 1
	VehicleNumberLabel.text = "Ukończone trasy: " + str(vehicles_finished)
	
func score_calc() -> void:
	score = vehicles_finished * 400
	GlobalData.set_score(score)

func _display_summary() -> void:
	if not displayed:
		displayed = true
		get_tree().paused = true
		score_calc()
		time.text = "Czas bez stłuczki: %s" % (start_time - time_left)
		cars.text = "Obsłużone samochody: %s" % vehicles_finished
		score_label.text = "Punkty: %s" % score
		animation_player.play("PanelShowUp") 
	

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	GameEvents.minigame_ended.emit()
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")
