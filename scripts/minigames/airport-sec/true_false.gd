extends Panel

@export var text:String
@export var category:String
@onready var label: Label = %Label

func _ready() -> void:
	label.text = text
