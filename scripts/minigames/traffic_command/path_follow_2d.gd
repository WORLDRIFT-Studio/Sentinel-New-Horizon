extends PathFollow2D

signal reached_stop
signal route_finished

@export var speed = 200.0
@export var stop_point_ratio = 0.5 # Zatrzymaj się w połowie trasy

var is_moving = true
var waiting_for_input = false

func _ready():
	loop = false
	rotates = true # Auto obraca się zgodnie z kierunkiem jazdy

func _process(delta):
	if not is_moving: return
	
	progress += speed * delta
	
	# Sprawdzanie punktu zatrzymania
	if not waiting_for_input and progress_ratio >= stop_point_ratio:
		progress_ratio = stop_point_ratio
		is_moving = false
		waiting_for_input = true
		reached_stop.emit()
	
	# Sprawdzanie końca trasy
	if progress_ratio >= 0.99:
		route_finished.emit()
		is_moving = false

func continue_moving():
	waiting_for_input = true # Flaga, żeby nie zatrzymał się drugi raz w tym samym miejscu
	is_moving = true

func reset():
	progress = 0
	is_moving = true
	waiting_for_input = false
