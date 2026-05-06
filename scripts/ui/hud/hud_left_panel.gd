extends Popup


@onready var panel: Panel = %Panel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var invisible_background: PanelContainer = %InvisibleBackground
@onready var title_label: Label = %Title
@onready var description_label: Label = %Description

var counter:int = 1
var minigames: Array[String] = ["res://scenes/minigames/airport-sec/airport_sec.tscn", 
									"res://scenes/minigames/trafic-command/traffic-command.tscn"]
var minigame: String

func _ready() -> void:
	minigames.shuffle()
	minigame = minigames[0]
	
func open_popup() -> void:
	self.show()
	animation_player.play("LeftPanel")
	
func setup() -> void:
	title_label.text = "Zgłoszenie nr. %02d" % counter 
	counter += 1
	description_label.text = "Lorem ipsum"


func _on_invisible_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			animation_player.play_backwards("LeftPanel")
			await animation_player.animation_finished
			self.hide()
			

func _on_accept_pressed() -> void:
	load(minigame)
