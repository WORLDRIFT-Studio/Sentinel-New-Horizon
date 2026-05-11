@tool
extends Control

@export_category("Upgrade Config")
@export_group("Upgrade")
@export var upgrade_id: String
@export var upgrades_required: Array[String] = []
@export_range(0, 100, 1, "prefer_slider") var upgrade_price: int = 10

@export_group("Display text")
@export var upgrade_name: String
@export_multiline() var upgrade_description: String
@export_multiline() var upgrades_effect: String

@onready var upgrade_name_label: Label = %UpgradeName
@onready var upgrade_price_label: Label = %UpgradePrice
@onready var upgrade_description_label: RichTextLabel = %Description
@onready var upgrade_effects_label: RichTextLabel = %Effects
@onready var upgrade: Button = %Upgrade

var new_price: int = 0
var is_unlocked: bool = false

func _ready() -> void:
	new_price = upgrade_price
	upgrade_name_label.text = upgrade_name
	upgrade_price_label.text = "%s Punktów Reputacji" % str(upgrade_price)
	upgrade_description_label.text = upgrade_description
	upgrade_effects_label.text = upgrades_effect
	
	
func update_ui(can_afford: bool, deps_met: bool) -> void:
	new_price = upgrade_price - upgrade_price * GlobalData.bonus["discount"]
	upgrade_price_label.text = "%s Punktów Reputacji" % str(new_price)
	
	
	if is_unlocked: # Jeśli odblokowane
		self.visible = true
	elif deps_met: # Jeśli można kupić i wymagane ulepszenia już są kupione
		if !can_afford: # Ale nas nie stać
			self.visible = true
	else: # Jeśli nieodblokowane lub nie są spełnione wymagania
		self.visible = false
		
