extends Panel

@export_category("Achivements")
@export_group("General")
@export var title: String = "Osiągnięcie"
@export var description: String = "Opis osiągnięcia."
@export var achivement_id: String

@onready var title_label: Label = %Title
@onready var description_label: RichTextLabel = %Description

func _ready() -> void:
	GameEvents.achievements_changed.connect(_on_achivemenets_changed)
	title_label.text = title
	description_label.text = description

func _on_achivemenets_changed() -> void:
	if achivement_id in AchivementsManager.unlocked_achievements:
		self.modulate = Color(1, 1, 1, 1)
	else:
		self.modulate = Color(1, 1, 1, 0.5)
