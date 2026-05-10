extends Node

signal reputation_changed(new_value:int)

var reputation: int = 5
var tutorial_done: bool = false

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

	
