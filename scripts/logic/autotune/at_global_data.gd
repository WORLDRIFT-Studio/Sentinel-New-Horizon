extends Node

signal reputation_changed(new_value:int)
signal bonus_changed()

var reputation: int = 5
var tutorial_done: bool = false
var bonus: Dictionary = {
	"day_duration": 0,
	"daily": 0,
	"discount": 0,
	"rep_multi": 1
}

func change_score(score: int) -> void:
	@warning_ignore("integer_division")
	reputation += score / 1000
	reputation_changed.emit(reputation)

func force_update() -> void:
	reputation_changed.emit(reputation)
	
func has_completed_tutorial() -> bool:
	return tutorial_done

func set_tutorial_completed() -> void:
	tutorial_done = true

	
