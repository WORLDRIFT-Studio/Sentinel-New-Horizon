extends CanvasLayer

# Notification Sound Effect by DRAGON-STUDIO from Pixabay

#region Export

@export_category("Ustawienia wstępne")
@export_group("Notifications")
@export var notify_tscn: PackedScene
@export var notify_container: Control

#endregion

#region Nodes

@onready var day_label: Label = %Day
@onready var clock: Label = %Clock
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var settings_menu: Popup = %SettingsMenu
@onready var upgrades_menu: Popup = %UpgradesMenu
@onready var achivements_menu: Popup = %AchivementsMenu
@onready var panel_sound: AudioStreamPlayer = %PanelSound
@onready var left_menu: Popup = %LeftMenu
@onready var rep_points: Label = %RepPoints
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sum_day: Label = %SumDay
@onready var sum_events: Label = %SumEvents
@onready var sum_rep_points: Label = %SumRepPoints
@onready var sum_bonus: Label = %SumBonus
@onready var sum_penalty: Label = %SumPenalty

#endregion

#region Setup

func _ready() -> void:
	GlobalData.connect("reputation_changed", _update_reputation)
	GlobalData.force_update() 
	GameEvents.connect("show_alert_description", _show_left_panel)
	TimeManager.connect("time_changed", _update_time)
	TimeManager.connect("day_changed", _update_day)
	TimeManager.connect("day_ended", _day_summary)
	TimeManager.force_update()
	TimeManager.start_timer()
	
#endregion

#region Clock

var animation_timer: float = 0.0

func _process(delta: float) -> void:
	if TimeManager.current_minutes >= TimeManager.end_minutes - 60:
		animation_timer += delta
		
		if int(animation_timer * 2) % 2 == 0: # Animacja zmiany koloru
			clock.modulate = Color.CRIMSON
		else:
			clock.modulate = Color.WHITE


func _update_time(hour, minutes) -> void:
	clock.text = "%02d : %02d" % [hour, minutes]


func _update_day(day) -> void: # Funkcja aktualizująca dzień
	day_label.text = "Dzień: %s" % day

#endregion

#region Popups

func _on_upgrades_button_button_down() -> void:
	upgrades_menu.open_popup(false)


func _on_continue_button_button_down() -> void:
	NotificationManager.notify("Zapisano grę !")
	animation_player.play_backwards("PanelShowUp")
	play()
	TimeManager.start_next_day()
	
	
func _show_left_panel() -> void:
	left_menu.open_popup()
	
	
func _day_summary() -> void:
	sum_day.text = "Podsumowanuie dnia %s" % TimeManager.current_day
	sum_rep_points.text = "Bilans RP: %s" % GlobalData.reputation_today
	sum_events.text = "Ukończonych zgłoszeń: %s" % GlobalData.finished_minigame
	sum_bonus.text = "Codzienny bonus: %s" % GlobalData.bonus["daily"]
	sum_penalty.text = "Kara: -%s" % GlobalData.penalty_today
	panel_sound.play()
	animation_player.play("PanelShowUp")
	pause()


#endregion

#region Stuff

func pause() -> void: # Zatrzymaj grę
	get_tree().paused = true

	
func play() -> void: # Wznów grę
	get_tree().paused = false

#endregion

#region Counters

func _update_reputation(value: int) -> void:
	rep_points.text = "%03d" % value 

#endregion
