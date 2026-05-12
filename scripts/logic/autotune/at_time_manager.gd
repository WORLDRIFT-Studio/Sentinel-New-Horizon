extends Node

#region Signals

signal time_changed(hour, minutes) # Gdy zmeinia sie czas
signal day_changed(day) # Gdy zmienia się dzień
signal day_ended # Gdy kończy się dzień
signal alert # Gdy ma pojawić się alert

#endregion

#region Variables

var start_hour: int = 8
var end_hour: int = 16
var step: int = 15
var clock_wait_time: float = 5

var current_day: int = 1
var current_minutes: int

var start_minutes: int
var end_minutes: int

var timer: Timer

var alerts_number: int
var alert_times: Array[int]

#endregion

#region Timer

func _ready() -> void:
	GlobalData.connect("bonus_changed", _update_end_time)
	GameEvents.connect("minigame_started", _stop_time)
	GameEvents.connect("minigame_ended", _start_time)
	
	start_minutes = start_hour * 60 
	end_minutes = end_hour * 60
	
	current_minutes = start_minutes
	current_day = 1
	
	time_changed.emit(start_hour, 0)
	
	alerts_number = randi_range(5, 10)
	_generate_alert_times()

func _start_time() -> void:
	timer.process_mode = Node.PROCESS_MODE_ALWAYS

func _stop_time() -> void:
	timer.process_mode = Node.PROCESS_MODE_DISABLED
	
func _update_end_time() -> void:
	end_minutes	= end_hour * 60 + GlobalData.bonus["day_duration"]
	
	
func _on_timer_timeout() -> void:
	current_minutes += step
	
	@warning_ignore("integer_division")
	var hour = current_minutes / 60
	var mins = current_minutes % 60
	
	time_changed.emit(hour, mins)
	
	if current_minutes in alert_times:
		alert.emit()
	
	if current_minutes >= end_minutes:
		day_ended.emit()
		timer.stop()
	
	if current_minutes == end_minutes - 60:
		NotificationManager.notify("Twoja zmiana dobiega końca")
	
	print("Godzina", current_minutes)


func _generate_alert_times() -> void:
	alert_times.clear()
	var times: Array[int] = []
	var check_time: int = start_minutes
	
	while check_time <= end_minutes - step:
		times.append(check_time)
		check_time += step
		
	times.shuffle() 
	for i in range(alerts_number):
		alert_times.append(times[i])
	print(alert_times)
		
				
func start_timer() -> void:
	if timer == null:
		timer = Timer.new()
		timer.wait_time = clock_wait_time
		timer.autostart = true
		timer.timeout.connect(_on_timer_timeout)
		add_child(timer)	
	

func start_next_day() -> void:
	current_minutes = start_minutes
	current_day += 1
	alerts_number = randi_range(5, 10)
	_generate_alert_times()
	day_changed.emit(current_day)
	timer.start()


func force_update() -> void:
	@warning_ignore("integer_division")
	var hour = current_minutes / 60
	var mins = current_minutes % 60
	
	time_changed.emit(hour, mins)
	day_changed.emit(current_day)


func get_clock() -> String:
	@warning_ignore("integer_division")
	return "%02d:%02d" % [current_minutes / 60, current_minutes % 60] 
	
#endregion
