extends CanvasLayer

# Notification Sound Effect by SoundShelfStudio from Pixabay

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

#endregion

#region Setup

func _ready() -> void:
	GameEvents.connect("show_alert_desciption", show_left_panel)
	TimeManager.connect("time_changed", update_time)
	TimeManager.connect("day_changed", update_day)
	TimeManager.connect("day_ended", day_summary)
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


func update_time(hour, minutes) -> void:
	clock.text = "%02d : %02d" % [hour, minutes]


func update_day(day) -> void: # Funkcja aktualizująca dzień
	day_label.text = "Dzień: %s" % day

#endregion

#region Popups

func _on_upgrades_button_button_down() -> void:
	upgrades_menu.open_popup(false)


func _on_continue_button_button_down() -> void:
	notify("Zapisano grę !")
	animation_player.play_backwards("HUD/PanelShowUp")
	play()
	TimeManager.start_next_day()
	
	
func show_left_panel() -> void:
	left_menu.open_popup()
	
	
func day_summary() -> void:
	panel_sound.play()
	animation_player.play("HUD/PanelShowUp")
	pause()


#endregion

#region Stuff

func notify(message:String) -> void: # Generator powiadomień
	var popup = notify_tscn.instantiate() 
	popup.setup(message)
	notify_container.add_child(popup)


func pause() -> void: # Zatrzymaj grę
	get_tree().paused = true

	
func play() -> void: # Wznów grę
	get_tree().paused = false

#endregion
