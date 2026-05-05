extends Node

# Notification Sound Effect by SoundShelfStudio from Pixabay

#region Export

@export_category("Ustawienia wstępne")
@export_group("Clock")
@export_range(0, 23, 1, "prefer_slider") var start_hour: int 
@export_range(0, 23, 1, "prefer_slider") var end_hour: int 
@export_range(0, 60, 5, "prefer_slider") var step: int
@export var clock_wait_time: float = 15.0 

@export_group("")
@export var notify_tscn: PackedScene
@export var notify_container: Control

#endregion

#region Nodes

@onready var day: Label = %Day
@onready var clock: Label = %Clock
@onready var timer: Timer = %Timer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var settings_menu: Popup = %SettingsMenu
@onready var upgrades_menu: Popup = %UpgradesMenu
@onready var achivements_menu: Popup = %AchivementsMenu
@onready var panel_sound: AudioStreamPlayer = %PanelSound

#endregion

#region Global Variables

var current_hour: int = 0
var animation_timer: float = 0.0
var animation_played: bool = false
var current_day: int = 0

#endregion

#region Setup

func _ready() -> void:
	timer.wait_time = clock_wait_time
	current_hour = start_hour * 60 # Minuty startowe
	end_hour *= 60 # Przeliczamy godzine koncowa na minuty
	update_time()
	update_day()
#endregion

#region Clock

func _on_timer_timeout() -> void: # Co x sekund aktualizuj czas
	update_time()

func _process(delta: float) -> void:
	if current_hour >= end_hour - 60:
		animation_timer += delta
		
		if int(animation_timer * 2) % 2 == 0: # Animacja zmiany koloru
			clock.modulate = Color.CRIMSON
		else:
			clock.modulate = Color.WHITE

func update_time() -> void:
	var minutes: int = current_hour % 60 # Obliczamy minuty 
	
	@warning_ignore("integer_division")
	var hour: int = (current_hour / 60) % 24 # Przeliczamy minuty na godziny
	
	clock.text = "%02d : %02d" % [hour, minutes]

	if current_hour >= end_hour and !animation_played:
		animation_played = true
		panel_sound.play()
		animation_player.play("HUD/PanelShowUp")
		get_tree().paused = true

	current_hour += step #  Zwiekszamy licznik o krok

#endregion

#region Popups

func _on_upgrades_button_button_down() -> void:
	upgrades_menu.open_popup(false)

func _on_continue_button_button_down() -> void:
	notify("Zapisano grę !")
	animation_player.play_backwards("HUD/PanelShowUp")
	play()
	update_day()
	reset()
	
#endregion

#region Stuff

func notify(message:String) -> void: # Generator powiadomień
	var popup = notify_tscn.instantiate() 
	popup.setup(message)
	notify_container.add_child(popup)

func update_day() -> void: # Funkcja aktualizująca dzień
	current_day += 1
	day.text = "Dzień: %s" % current_day

func reset() -> void: # Funkcja resetująca zmienne
	current_hour = start_hour * 60 # Reset czas
	animation_played = false # Reset flagi
	update_time() # Reload
	
func pause() -> void: # Zatrzymaj grę
	get_tree().paused = true
	
func play() -> void: # Wznów grę
	get_tree().paused = false
	
#endregion
