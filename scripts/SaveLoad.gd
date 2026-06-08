extends Node

const SAVE_LOCATION = "user://SaveFile.dat"
const PASS = "8fgds97ghy"

const DEFAULT_SAVE: Dictionary = {
	"volume_master": 0.5,
	"volume_music": 0.5,
	"volume_sfx": 0.5,
	"days": 1,
	"minutes": 480,
	"reputation": 100,
	"bonus": {
		"day_duration": 0,
		"daily": 0,
		"discount": 0,
		"rep_multi": 1
	},
	"unlocked_upgrades": [],
	"unlocked_achievements": [],
	"tutorial": {
		"traffic_command": false,
		"airport_sec": false,
		"emergency_rush": false,
	},
}

var contents_to_save: Dictionary = DEFAULT_SAVE.duplicate()

func _reset():
	contents_to_save = DEFAULT_SAVE.duplicate()

func save_content():
	var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.WRITE, PASS)
	if file == null:
		push_error("Nie można otworzyć pliku do zapisu: %s" % FileAccess.get_open_error())
		return
	file.store_var(contents_to_save.duplicate())
	file.close()

func load_content():
	if not FileAccess.file_exists(SAVE_LOCATION):
		return
	
	var file = FileAccess.open_encrypted_with_pass(SAVE_LOCATION, FileAccess.READ, PASS)
	if file == null:
		push_error("Nie można otworzyć pliku do odczytu: %s" % FileAccess.get_open_error())
		return
	
	var data = file.get_var()
	file.close()
	
	if not data is Dictionary:
		push_error("Uszkodzone dane zapisu!")
		return
	
	for key in contents_to_save:
		if data.has(key):
			contents_to_save[key] = data[key]
