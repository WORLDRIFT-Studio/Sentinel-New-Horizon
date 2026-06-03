#Napisany przy pomocy claude
extends Node

@onready var animation_panel: AnimationPlayer = $AnimationPlayer
@onready var tutor_txt: Label = $Panel/tutor_txt
@onready var shadow1: Node = $shadow1
@onready var timer: Panel = $Menu/HBoxContainer/Panel
@onready var vehicle_number: Panel = $Menu/HBoxContainer/Panel2
@onready var left_car: Node2D = $Left/Right/PathFollow2D/Node2D
@onready var down_car: Node2D = $Down/Right/PathFollow2D/Node2D
@onready var right_car: Node2D = $Right/Right/PathFollow2D/Node2D
@onready var up_car: Node2D = $Up/Right/PathFollow2D/Node2D
@onready var left_car_time: Label = $Left/Right/PathFollow2D/Node2D/Timer
@onready var down_car_time: Label = $Down/Right/PathFollow2D/Node2D/Timer
@onready var right_car_time: Label = $Right/Right/PathFollow2D/Node2D/Timer
@onready var up_car_time: Label = $Up/Right/PathFollow2D/Node2D/Timer

var tutorial_step: int = 0
var is_tutorial: bool = false
var directions: Array = []

var direction_timers: Array[float] = [10.0, 10.0, 10.0, 10.0]
var timer_limits: Array[float] = [10.0, 10.0, 10.0, 10.0]
var timer_active: Array[bool] = [false, false, false, false]

@onready var ui = $Menu
signal crash

func _ready() -> void:
	directions = [
		{ 
			"followers": [$Left/Right/PathFollow2D, $Left/Straight/PathFollow2D, $Left/Left/PathFollow2D], 
			"paths": [$Left/Right, $Left/Straight, $Left/Left], 
			"vehicle": $Left/Right/PathFollow2D/Node2D, 
			"active_index": -1, 
			"active_follower": null 
		},
		{ 
			"followers": [$Down/Right/PathFollow2D, $Down/Straight/PathFollow2D, $Down/Left/PathFollow2D], 
			"paths": [$Down/Right, $Down/Straight, $Down/Left], 
			"vehicle": $Down/Right/PathFollow2D/Node2D, 
			"active_index": -1, 
			"active_follower": null 
		},
		{ 
			"followers": [$Right/Right/PathFollow2D, $Right/Straight/PathFollow2D, $Right/Left/PathFollow2D], 
			"paths": [$Right/Right, $Right/Straight, $Right/Left], 
			"vehicle": $Right/Right/PathFollow2D/Node2D, 
			"active_index": -1, 
			"active_follower": null 
		},
		{ 
			"followers": [$Up/Right/PathFollow2D, $Up/Straight/PathFollow2D, $Up/Left/PathFollow2D], 
			"paths": [$Up/Right, $Up/Straight, $Up/Left], 
			"vehicle": $Up/Right/PathFollow2D/Node2D, 
			"active_index": -1, 
			"active_follower": null 
		}
	]
	shadow1.visible = false
	
	if _is_first_run():
		start_tutorial()
	
	for i in range(directions.size()):
		var d = directions[i]
		d["vehicle"].get_node("Area2D").crashed.connect(_on_crash)
		_pick_random(i)

func _is_first_run() -> bool:
	return not GlobalData.has_completed_tutorial2()

func set_tutor_text(new_text: String) -> void:
	tutor_txt.text = new_text
	tutor_txt.visible_characters = 0
	var tween = create_tween()
	tween.tween_property(tutor_txt, "visible_characters", new_text.length(), 0.01 * new_text.length())

func start_tutorial() -> void:
	is_tutorial = true
	tutorial_step = 0

	shadow1.visible = false
	up_car_time.visible = false
	right_car_time.visible = false
	left_car_time.visible = false
	down_car_time.visible = false
	
	timer.visible = false
	vehicle_number.visible = false
	
	set_process(false)
	
	tutor_txt.mouse_filter = Control.MOUSE_FILTER_STOP
	
	await get_tree().create_timer(2.0).timeout
	animation_panel.play("panel_anim")
	tutor_txt.visible = true
	set_tutor_text("Witaj w sekcji szkoleniowej traffic. Aby rozpocząć szkolenie kliknij w pokazany tekst.")
	
	if not tutor_txt.gui_input.is_connected(_on_tutor_txt_clicked):
		tutor_txt.gui_input.connect(_on_tutor_txt_clicked)

func _on_tutor_txt_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_advance_tutorial()

func _advance_tutorial() -> void:
	tutorial_step += 1
	
	match tutorial_step:
		1:
			print("Tutoail I/IV")
			shadow1.visible = true
			set_tutor_text("To jest twoja lista rzeczy, które musisz sprawdzić oraz dobrze zdefiniować. UWAŻAJ, gdyż właśnie z tej listy będziesz rozliczany.")

		#2:
			#arrow1.visible = false
			#arrow2.visible = true
			#set_tutor_text("To jest dowód oraz paszport aktualnie sprawdzanego człowieka. To stąd będziesz brał większość informacji. Lepiej sprawdzić oba, gdyż niektóre dane mogą się ze sobą nie zgadzać.")

		#3:
			#arrow2.visible = false
			#arrow4.visible = true
			#set_tutor_text("To jest lista poszukiwanych. Tutaj sprawdzisz, czy dana osoba nie jest ścigana przez policję. Jeżeli jest, zarejestruj to na swojej liście.")

		#4:
			#arrow4.visible = false
			#set_tutor_text("To już wszystko co musisz wiedzieć. Powodzenia!")

		#5:
			# Koniec tutorialu — zapisz i przeładuj scenę
			#GlobalData.set_tutorial_completed()
			#tutor_txt.gui_input.disconnect(_on_tutor_txt_clicked)
			#get_tree().reload_current_scene()

#endregion

func _process(delta: float) -> void:
	for i in range(directions.size()):
		if not timer_active[i]: continue
		
		direction_timers[i] -= delta
		var vehicle = directions[i]["vehicle"]
		vehicle.get_node("Timer").text = str(snapped(direction_timers[i], 0.1))+"s"
		
		# Proste mruganie na czerwono poniżej 5s
		if direction_timers[i] <= 5.0:
			var pulse = floor(direction_timers[i] * 10)
			vehicle.get_node("Sprite2D").modulate = Color.RED if int(pulse) % 2 == 0 else Color.WHITE
		
		if direction_timers[i] <= 0:
			_force_continue(i)

func _pick_random(index: int) -> void:
	var d = directions[index]
	
	# Odłączanie starych sygnałów - używamy .bind() zamiast lambdy, aby móc się rozłączyć
	if d["active_follower"] != null:
		d["paths"][d["active_index"]].hide_path()
		var area = d["vehicle"].get_node("Area2D")
		
		# Rozłączamy wszystko, co było podpięte pod ten konkretny index
		if d["active_follower"].reached_stop.is_connected(_on_reached_stop.bind(index)):
			d["active_follower"].reached_stop.disconnect(_on_reached_stop.bind(index))
		if d["active_follower"].route_finished.is_connected(_on_route_finished.bind(index)):
			d["active_follower"].route_finished.disconnect(_on_route_finished.bind(index))
		if area.clicked.is_connected(_on_vehicle_clicked.bind(index)):
			area.clicked.disconnect(_on_vehicle_clicked.bind(index))

	# Losowanie nowej trasy
	var new_index = randi() % 3
	while new_index == d["active_index"]: new_index = randi() % 3
	
	d["active_index"] = new_index
	d["active_follower"] = d["followers"][new_index]
	
	# Reparenting i reset
	d["vehicle"].reparent(d["active_follower"], false)
	d["vehicle"].position = Vector2.ZERO
	d["vehicle"].scale = Vector2.ONE
	d["vehicle"].get_node("Sprite2D").modulate = Color.WHITE
	d["vehicle"].get_node("Timer").visible = false
	
	d["paths"][new_index].show_path()
	d["active_follower"].reset()
	
	# Łączenie nowych sygnałów z użyciem BIND
	d["active_follower"].reached_stop.connect(_on_reached_stop.bind(index))
	d["active_follower"].route_finished.connect(_on_route_finished.bind(index))

func _on_reached_stop(index: int) -> void:
	var d = directions[index]
	var area = d["vehicle"].get_node("Area2D")
	area.enable_click()
	
	direction_timers[index] = timer_limits[index]
	timer_active[index] = true
	d["vehicle"].get_node("Timer").visible = true
	
	if not area.clicked.is_connected(_on_vehicle_clicked.bind(index)):
		area.clicked.connect(_on_vehicle_clicked.bind(index))

func _on_vehicle_clicked(index: int) -> void:
	timer_active[index] = false
	var d = directions[index]
	d["vehicle"].get_node("Timer").visible = false
	d["vehicle"].get_node("Sprite2D").modulate = Color.WHITE
	d["active_follower"].continue_moving()

func _force_continue(index: int) -> void:
	timer_active[index] = false
	var d = directions[index]
	var area = d["vehicle"].get_node("Area2D")
	area.clickable = false # Upewnij się, że Area2D ma tę zmienną
	d["vehicle"].get_node("Timer").visible = false
	d["active_follower"].continue_moving()

func _on_route_finished(index: int) -> void:
	ui.add_finished_vehicle()
	_pick_random(index)

func _on_crash() -> void:
	get_tree().paused = true
	crash.emit()
