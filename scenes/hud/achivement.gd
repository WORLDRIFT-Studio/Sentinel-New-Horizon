extends Panel

@export_category("Achivements")
@export_group("General")
@export var title: String = "Osiągnięcie"
@export var description: String = "Opis osiągnięcia."
@export var achievement_id: String

@onready var title_label: Label = %Title
@onready var description_label: RichTextLabel = %Description

func _ready() -> void:
	if material: material = material.duplicate(true)
	GameEvents.achievements_changed.connect(_on_achivemenets_changed)
	title_label.text = title
	description_label.text = description
	_on_achivemenets_changed()

func _on_achivemenets_changed() -> void:
		var is_unlocked: bool = achievement_id in AchivementsManager.unlocked_achievements
		
		print("Panel: ", title, " | ID: ", achievement_id, " | Odblokowane?: ", is_unlocked)

		material.set_shader_parameter("enable", !is_unlocked)
