extends Node

var scores: int = 0
var tutorial_done: bool = false

func save_score(score: int) -> void:
	scores = score
	print("Zapisano wynik w GlobalData: ", scores)

func has_completed_tutorial() -> bool:
	return tutorial_done

func set_tutorial_completed() -> void:
	tutorial_done = true
