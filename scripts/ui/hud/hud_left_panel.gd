extends Popup


@onready var panel: Panel = %Panel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var invisible_background: PanelContainer = %InvisibleBackground
@onready var title_label: Label = %Title
@onready var description_label: Label = %Description
@onready var difficulty_label: Label = %Difficulty
@onready var date_label: Label = %Date

var path_to_scene: String
var last_alert: Node2D

func _ready() -> void:
	GameEvents.connect("show_alert_description", open_popup)
	
func open_popup(sender:Node2D, titl:String, desc:String, dif:String, date:String, path:String) -> void:
	self.show()
	last_alert = sender
	animation_player.play("LeftPanel")
	title_label.text = titl
	description_label.text = desc
	difficulty_label.text = dif
	date_label.text = date
	path_to_scene = path

func _on_invisible_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			animation_player.play_backwards("LeftPanel")
			await animation_player.animation_finished
			self.hide()
			
func _on_accept_pressed() -> void:
	if is_instance_valid(last_alert):
		last_alert.get_parent().remove_child(last_alert)
		last_alert.queue_free()
	GameEvents.minigame_started.emit()
	_load_minigame()
	
	
	
func _load_minigame() -> void:
	TransitionScene.fade_to_scene(path_to_scene)
	self.hide()
