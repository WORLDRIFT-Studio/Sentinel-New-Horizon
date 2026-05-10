extends Popup


@onready var panel: Panel = %Panel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var invisible_background: PanelContainer = %InvisibleBackground
@onready var title_label: Label = %Title
@onready var description_label: Label = %Description
@onready var difficulty_label: Label = %Difficulty
@onready var date_label: Label = %Date

var path_to_scene: String


func _ready() -> void:
	GameEvents.connect("show_alert_description", open_popup)
	
func open_popup(titl:String, desc:String, dif:String, date:String, path:String) -> void:
	self.show()
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
	var minigame = load(path_to_scene).instantiate()
	
	get_tree().root.add_child(minigame)
	
	get_tree().paused = true
	
	self.hide()
