extends Node2D

signal amublanse_hit(distance: float)

const SCROLL_SPEED : float = 400.0
const PIXELS_PER_METER = 16.64

var distance : float = 0.0:
	set(new_value):
		distance = clampf(new_value, 0, 5000)	
var fuel_full : float = 10.0
var fuel : float = 10.0
@onready var tutorial: AnimationPlayer = %Tutorial

@onready var score_label: Label = %ScoreLabel
@onready var fuel_gauge: Control = %FuelGauge
@onready var ambulance:  CharacterBody2D = %Ambulance
@onready var spawner: Node2D = %Spawner
var tutorial_step: int = 0
var is_tutorial: bool = false
var tutorial_done = false

@onready var tutor_txt: Label = $Panel/tutor_txt
@onready var animation_panel: AnimationPlayer= $AnimationPanel


func _ready() -> void:
	if _is_first_run():
		start_tutorial()

func _is_first_run() -> bool:
	return not GlobalData.has_completed_tutorial3()

var can_advance: bool = false

func set_tutor_text(new_text: String) -> void:
	can_advance = false  # Blokuj podczas animacji
	tutor_txt.text = new_text
	tutor_txt.visible_characters = 0
	
	var tween = create_tween()
	tween.tween_property(tutor_txt, "visible_characters", new_text.length(), 0.01 * new_text.length())
	tween.tween_callback(func(): can_advance = true)  # Odblokuj po animacji

func _input(event: InputEvent) -> void:
	if not is_tutorial or tutorial_done or not can_advance:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		can_advance = false  # Zapobiega podwójnemu kliknięciu
		_advance_tutorial()

func start_tutorial() -> void:
	is_tutorial = true
	tutorial_step = 0
	
	spawner.process_mode = Node.PROCESS_MODE_DISABLED
	fuel_gauge.visible = false
	
	tutorial.play("panel_anim")
	tutor_txt.visible = true
	set_tutor_text("Witaj w sekcji szkoleniowej sterowania wozem ratunkowym. Aby rozpocząć szkolenie kliknij w pokazany tekst.")

func _advance_tutorial() -> void:
	tutorial_step += 1
	
	match tutorial_step:
		1:
			set_tutor_text("Unikaj innych pojazdów na drodze poruszając w lewo i prawo za pomocą: ← i →")

		2:
			set_tutor_text("Zbieraj kanistry z benzynom po drodze, by nie skończyło ci się paliwo.")

		3:
			set_tutor_text("Z każdym metrem jakim przejedziesz zwiękasza się twoja prędkość")

		4:
			set_tutor_text("To już wszytko co musisz wiedzieć. Powodzenia!")

		5:
			tutorial_done = true
			is_tutorial = false
			spawner.process_mode = Node.PROCESS_MODE_INHERIT
			GlobalData.set_tutorial3_completed()
			get_tree().reload_current_scene()

func _process(delta):
	if not is_tutorial:
		distance += (SCROLL_SPEED / PIXELS_PER_METER) * delta
		fuel = max(0.0, fuel - delta * 0.15)
		

		fuel = max(0.0, fuel - delta * 0.6)
		if fuel <= 0.0:
			on_ambulance_hit()
		if fuel == 10.0:
			fuel_gauge.restore_fuel()
		else:
			fuel_gauge.set_fuel(fuel, fuel_full)
	
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
