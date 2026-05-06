extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var alert_number: int = 0
var options = {
	"airport": {
		"path": "res://scenes/minigames/airport-sec/airport_sec.tscn",
		"difficulty": "trudny",
		"description": """Sprawdzaj dokumenty pasażerów, aby zadbać o bezpieczeństwo.
Musisz szybko decydować, kogo przepuścić, a kogo zatrzymać, zanim skończy
się czas i zablokuje kolejkę."""
	},
	"traffic": {
		"path": "res://scenes/minigames/traffic/traffic.tscn", # Zakładam, że tu ma być inna ścieżka
		"difficulty": "umiarkowany",
		"description": """Zarządzaj ruchem drogowym, zachowując przy tym płynność,
zapobiegaj kolizjom, aby nie zakorkować miasta i uniknąć katastrofy."""
	}
}
var option: Dictionary
var title: String
var desc: String
var difficulty: String
var date: String
var path: String

func _ready() -> void:
	var keys: Array = options.keys()
	keys.shuffle()	
	alert_number += get_tree().get_node_count_in_group("alert")
	
	option = options[keys[0]]
	title = "Zgłoszenie: %02d" % alert_number
	desc = "Opis: %s" % option["description"]
	difficulty = "Poziom trduności: %s" % option["difficulty"]
	date = "Zgłoszono: %s" % TimeManager.get_clock()
	path = option["path"]
	
	animation_player.play("spawn")
	await animation_player.animation_finished
	animation_player.play("alert")

	
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			GameEvents.show_alert_description.emit(title, desc, difficulty, date, path)
