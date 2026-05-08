extends MarginContainer

@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var content: Label = %Label
var _temp: String

func _ready() -> void:
	content.text = _temp
	animation.play("SaveNotification")
	await animation.animation_finished
	await get_tree().create_timer(4.0).timeout
	animation.play_backwards("SaveNotification")
	await animation.animation_finished 
	queue_free()

func setup(message: String) -> void:
	_temp = message
	if content:
		content.text = message

	
