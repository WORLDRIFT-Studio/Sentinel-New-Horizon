extends Node

signal reputation_changed(new_value:int)

@warning_ignore("unused_signal")
signal bonus_changed()

var reputation: int = 100
var tutorial_done: bool = false
var bonus: Dictionary = {
	"day_duration": 0,
	"daily": 0,
	"discount": 0,
	"rep_multi": 1
}
var finished_minigame: int = 0
var reputation_today: int = 0
var penalty_today: int = 0

func _ready() -> void:
	TimeManager.connect("day_changed", _reset_stats)
	TimeManager.connect("day_ended", _daily_summary)
	
func _reset_stats() -> void:
	finished_minigame = 0
	reputation_today = 0
	
func _daily_summary() -> void:
	update_reputation(bonus["daily"])
	penalty()
	update_reputation(-penalty_today)
	
func penalty() -> void:
	penalty_today = TimeManager.alerts_number - finished_minigame
	
func change_score(score: int) -> void:
	@warning_ignore("integer_division")
	var points = score / 1000 
	update_reputation(points)
	
func update_reputation(value: int) -> void:
	reputation += value * bonus["rep_multi"]
	reputation_today += value * bonus["rep_multi"]
	reputation_changed.emit(reputation)
	print(reputation, "REPUTACJA")

func force_update() -> void:
	reputation_changed.emit(reputation)
	
func has_completed_tutorial() -> bool:
	return tutorial_done

func set_tutorial_completed() -> void:
	tutorial_done = true

	
