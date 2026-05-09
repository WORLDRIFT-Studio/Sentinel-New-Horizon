extends GridContainer

var unlocked_ids: PackedStringArray = []

func _ready() -> void:

	for child in get_children():
		if child == Button:
			child.pressed.connect(_on_upgrade_clicked.bind(child))
	check_upgrades()
	

func _on_upgrade_clicked(upgrade:Node) -> void:
	if GlobalData.reputation >= upgrade.upgrade_price:
		GlobalData.reputation -= upgrade.upgrade_price
		upgrade.is_unlocked = true
		unlocked_ids.append(upgrade.id)

func check_upgrades() -> void:
	for child in get_children():
		var deps_met = true
		for r in child.upgrades_required:
			if r not in unlocked_ids:
				deps_met = false
		child.update_ui(GlobalData.reputation >= child.upgrade_price, deps_met)
