extends GridContainer

var unlocked_ids: PackedStringArray = []

func _ready() -> void:

	for child in self.get_children():
		child.upgrade.pressed.connect(_on_upgrade_clicked.bind(child))
	check_upgrades()
	

func _on_upgrade_clicked(upgrade:Node) -> void:
	if GlobalData.reputation >= upgrade.new_price:
		GlobalData.update_reputation(-upgrade.new_price)
		print(-upgrade.new_price)
		NotificationManager.notify("Zakupiono ulepszenie: %s" % \
									upgrade.upgrade_name) 
		upgrade.is_unlocked = true
		unlocked_ids.append(upgrade.upgrade_id)
		update(upgrade)
		upgrade.queue_free()
		check_upgrades()
		
	elif GlobalData.reputation < upgrade.new_price:
		NotificationManager.notify("Nie stać cię na zakup ulepszenia")
	
func check_upgrades() -> void:
	for child in get_children():
		var deps_met = true
		for r in child.upgrades_required:
			if r not in unlocked_ids:
				deps_met = false
		child.update_ui(GlobalData.reputation >= child.new_price, deps_met)
		
func update(upgrade: Node) -> void:
	match upgrade.upgrade_id:
		"longer_day":
			GlobalData.bonus["day_duration"] += 120
		"trust_level":
			GlobalData.bonus["rep_multi"] += 0.5
		"daily":
			GlobalData.bonus["daily"] += 5
		"discount":
			GlobalData.bonus["discount"] += 0.2
	GlobalData.emit_signal("bonus_changed")
