extends Panel

@export var user_name: String
@export var user_function: String
@export var user_github: String
@export_multiline() var user_bio: String

@onready var label_name: Label = %Name
@onready var label_github: Label = %Github
@onready var label_function: Label = %Function
@onready var label_click_me: RichTextLabel = %ClickMe
@onready var label_bio: RichTextLabel = $MarginContainer/VBoxContainer/Bio

func _ready() -> void:
	label_name.text = user_name
	label_function.text = user_function
	label_click_me.text = "[url=%s]Click Me To Visit![/url]"
	label_bio.text = str(user_bio)
	

func _on_click_me_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
