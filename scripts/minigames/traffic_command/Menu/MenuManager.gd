extends Control

@onready var timer = $Timer
@onready var TimerLabel = $HBoxContainer/Panel/TimerLabel
@onready var VehicleNumberLabel = $HBoxContainer/Panel2/VehicleNumberLabel

var time_left = 60
var vehicles_finished = 0

func _ready():
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
		get_tree().paused = true

func add_finished_vehicle() -> void:
	vehicles_finished += 1
	VehicleNumberLabel.text = "Ukończone trasy: " + str(vehicles_finished)
