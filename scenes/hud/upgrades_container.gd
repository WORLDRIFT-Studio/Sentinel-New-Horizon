extends GridContainer

var unlocked_ids: PackedStringArray = []

func _ready() -> void:

	for child in self.get_children():
		child.upgrade.pressed.connect(_on_upgrade_clicked.bind(child))
	check_upgrades()
	

func _on_upgrade_clicked(upgrade:Node) -> void:
	if GlobalData.reputation >= upgrade.upgrade_price:
		GlobalData.change_score(-upgrade.upgrade_price)
		NotificationManager.notify("Zakupiono ulepszenie: %s" % \
									upgrade.upgrade_name) 
		upgrade.is_unlocked = true
		unlocked_ids.append(upgrade.id)
		upgrade.queue_free()
		
	elif GlobalData.reputation < upgrade.upgrade_price:
		NotificationManager.notify("Nie stać cię na zakup ulepszenia")
	
func check_upgrades() -> void:
	for child in get_children():
		var deps_met = true
		for r in child.upgrades_required:
			if r not in unlocked_ids:
				deps_met = false
		child.update_ui(GlobalData.reputation >= child.upgrade_price, deps_met)
		
