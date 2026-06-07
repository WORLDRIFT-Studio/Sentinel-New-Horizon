extends Node2D

signal amublanse_hit(distance: float)

const SCROLL_SPEED : float = 400.0
const PIXELS_PER_METER = 16.64

var distance : float = 0.0:
	set(new_value):
		distance = clampf(new_value, 0, 5000)	
var fuel_full : float = 10.0
var fuel : float = 10.0

@onready var score_label: Label = %ScoreLabel
@onready var fuel_gauge: Control = %FuelGauge
@onready var ambulance:  CharacterBody2D = %Ambulance
@onready var spawner: Node2D = %Spawner

func _process(delta):
	distance += (SCROLL_SPEED / PIXELS_PER_METER) * delta
	fuel = max(0.0, fuel - delta * 0.6)
	
	if fuel <= 0.0:
		on_ambulance_hit()
	
	if distance < 1000.0:
		score_label.text = "Dystans: %d m / 5km" % int(distance)
	else:
		score_label.text = "Dystans: %.2f km / 5km" % (distance / 1000.0)
	
	if distance >= 5000:
		on_ambulance_hit()
	
	if fuel == 10.0:
		fuel_gauge.restore_fuel()
	else:
		fuel_gauge.set_fuel(fuel, fuel_full)


func on_ambulance_hit():
	amublanse_hit.emit(distance)
	get_tree().paused = true
	

func _fuel_restored():
	fuel = fuel_full
