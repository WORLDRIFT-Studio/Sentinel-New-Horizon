extends Node

const ACHIEVEMENTS: Dictionary = {
	"1_day": "Ukończ jeden dzień.",
	"5_day": "Ukończ pięć dni.",
	"10_day": "Ukończ dziesięć dni.",
	"50_rep": "Zdobądź 50 PR.",
	"100_rep": "Zdobądź 100 PR.",
	"1_upgrade": "Zdobądź pierwsze ulepszenie.",
	"all_upgrades": "Zdobądź wszystkie ulepszenia."
}

var unlocked_achievements: Array = []

func _ready() -> void:
	GlobalData.reputation_changed.connect(_on_reputation_changed)
	TimeManager.day_ended.connect(_on_day_changed)
	GameEvents.upgrades_changed.connect(_on_upgrade_changed)

func _on_reputation_changed() -> void:
	if GlobalData.reputation >= 50:
		_unlock_achievement("50_rep")
	if GlobalData.reputation >= 100:
		_unlock_achievement("100_rep")

func _on_day_changed() -> void:
	match TimeManager.current_day:
		1:
			_unlock_achievement("1_day")
		5:
			_unlock_achievement("5_day")
		10:
			_unlock_achievement("10_day")

func _on_upgrade_changed() -> void:
	if GlobalData.upgrades_bought == 1:
		_unlock_achievement("1_upgrade")
	if GlobalData.upgrades_bought == GlobalData.upgrades_count:
		_unlock_achievement("all_upgrades")

func _unlock_achievement(id: String) -> void:
	if id in unlocked_achievements:
		return
	unlocked_achievements.append(id)
	NotificationManager.notify("Odblokowano osiągnięcie: %s" % ACHIEVEMENTS.get(id, id))
	GameEvents.achievements_changed.emit()
