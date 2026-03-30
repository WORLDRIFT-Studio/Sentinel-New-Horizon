extends Panel

@export_category("Ustawienia własne")
@export_subgroup("Label")
@export var settings:String 
@export var default:bool
@onready var textBlock:Label = %Label
@onready var checkbox:CheckButton = %CheckButton

func _ready() -> void:
	textBlock.text = settings
	checkbox.button_pressed = default

func _on_check_button_toggled(toggled_on: bool) -> void:
	GameEvents.checkbox_marked.emit(settings, toggled_on)
