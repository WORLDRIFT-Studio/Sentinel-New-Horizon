extends Node

var scores: int = 0

func save_score(score: int) -> void:
	scores = score
	print("Zapisano wynik w GlobalData: ", scores)
