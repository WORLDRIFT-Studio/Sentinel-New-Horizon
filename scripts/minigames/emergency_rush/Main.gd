extends Node2D

const SCROLL_SPEED = 400.0
const PIXELS_PER_METER = 16.64

var distance = 0.0
var fuel_full = 10.0
var fuel = 10.0

@onready var score_label = $UI/ScoreLabel
@onready var ambulance = $Ambulance
@onready var spawner = $Spawner
@onready var fuel_gauge = $UI/FuelGauge

func _process(delta):
	distance += (SCROLL_SPEED / PIXELS_PER_METER) * delta
	fuel = max(0.0, fuel - delta * 0.6)
	
	if fuel <= 0.0:
		on_ambulance_hit()
	
	if distance < 1000.0:
		score_label.text = "Dystans: %d m" % int(distance)
	else:
		score_label.text = "Dystans: %.2f km" % (distance / 1000.0)
	if fuel == 10.0:
		fuel_gauge.restore_fuel()
	else:
		fuel_gauge.set_fuel(fuel, fuel_full)

func on_ambulance_hit():
	get_tree().paused = true

func _fuel_restored():
	fuel = fuel_full
