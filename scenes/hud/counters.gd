extends VBoxContainer

@export_category("Ustawienia wstępne")
@export_group("Clock")
@export_range(0, 23, 1, "prefer_slider") var start_hour: int = 10
@export_range(0, 23, 1, "prefer_slider") var end_hour: int = 20
@export_range(0, 60, 5, "prefer_slider") var step: int = 15
@export var clock_wait_time: float = 15.0 


@onready var day: Label = $Day
@onready var clock: Label = %Clock
@onready var timer: Timer = %Timer

var current_hour: int = start_hour * 60 # Minuty startowe
var animation_flag: bool = false
var animation_timer: float = 0.0

func _ready() -> void:
	timer.wait_time = clock_wait_time
	end_hour *= 60 # Przeliczamy godzine koncowa na minuty
	
	#region Wstepnioe ustawiamy zegar
	var minutes: int = current_hour % 60 # Obliczamy minuty 
	var hour: int = int(floor(current_hour / 60)) # Przeliczamy minuty na godziny
	
	clock.text = "%02d : %02d" % [hour, minutes]
	current_hour += step #  Zwiekszamy licznik o krok
	#endregion


func _on_timer_timeout() -> void:
	update_time()


func _process(delta: float) -> void:
	if current_hour >= end_hour - 60:
		animation_timer += delta
		
		if int(animation_timer) % 2 == 0:
			clock.modulate = Color.CRIMSON
		else:
			clock.modulate = Color.WHITE
		
	
	
func update_time() -> void:
	var minutes: int = current_hour % 60 # Obliczamy minuty 
	var hour: int = floor(current_hour / 60) # Przeliczamy minuty na godziny
	
	clock.text = "%02d : %02d" % [hour, minutes]
	current_hour += step #  Zwiekszamy licznik o krok
	
