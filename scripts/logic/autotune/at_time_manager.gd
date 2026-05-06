extends Node

#region Signals

signal time_changed(hour, minutes)
signal day_changed(day)
signal day_ended

#endregion

#region Variables

var start_hour: int = 8
var end_hour: int = 10
var step: int = 60
var clock_wait_time: float = 2.0 

var current_minutes: int
var current_day: int

var start_minutes: int
var end_minutes: int

var timer: Timer

#endregion

#region Timer

func _ready() -> void:
	start_minutes = start_hour * 60
	end_minutes = end_hour * 60
	
	current_minutes = start_minutes
	current_day = 1
	
	time_changed.emit(start_hour, 0)
	

func _on_timer_timeout() -> void:
	current_minutes += step
	
	@warning_ignore("integer_division")
	var hour = current_minutes / 60
	var mins = current_minutes % 60
	
	time_changed.emit(hour, mins)
	
	if current_minutes >= end_minutes:
		day_ended.emit()
		timer.stop()
		
		
func start_timer() -> void:
	timer = Timer.new()
	timer.wait_time = clock_wait_time
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	

func start_next_day() -> void:
	current_minutes = start_minutes
	current_day += 1
	day_changed.emit(current_day)
	timer.start()


func force_update() -> void:
	@warning_ignore("integer_division")
	var hour = current_minutes / 60
	var mins = current_minutes % 60
	
	time_changed.emit(hour, mins)
#endregion
