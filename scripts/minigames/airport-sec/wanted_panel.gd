# Kod wspomagany AI
# =================
extends Panel

# === Referencje dopasowane do Twojego drzewa ===
@onready var input_id    : LineEdit = $MarginContainer/VBoxContainer/LineEdit
@onready var label_id    : Label    = $MarginContainer/VBoxContainer/ScrollContainer/Label

@onready var input_name  : LineEdit = $MarginContainer2/VBoxContainer/LineEdit
@onready var label_name  : Label    = $MarginContainer2/VBoxContainer/ScrollContainer/Label

# === Dane wewnętrzne ===
var _current_npc  : NPC    = null
var _wanted_value : String = ""
var _wanted_by    : String = ""   # "id" lub "name"

const COLOR_NORMAL := Color(0.6, 0.6, 0.6)
const COLOR_WANTED := Color(1.0, 0.2, 0.2)

# ---------------------------------------------------------------
func _ready() -> void:
	_reset_labels()
	input_id.text_changed.connect(_on_id_changed)
	input_name.text_changed.connect(_on_name_changed)

# ---------------------------------------------------------------
func load_npc(npc: NPC) -> void:
	_current_npc = npc
	input_id.text   = ""
	input_name.text = ""
	_reset_labels()

	if not npc.is_wanted:
		_wanted_value = ""
		_wanted_by    = ""
		return

	_wanted_by = npc.wanted_by
	match _wanted_by:
		"id":
			_wanted_value = npc.id
		"name":
			_wanted_value = "%s %s" % [npc.name, npc.surname]

# ---------------------------------------------------------------
func _on_id_changed(new_text: String) -> void:
	if _wanted_by != "id":
		return
	_check(new_text, label_id)

func _on_name_changed(new_text: String) -> void:
	if _wanted_by != "name":
		return
	_check(new_text, label_name)

# ---------------------------------------------------------------
func _check(input: String, label: Label) -> void:
	if input.strip_edges().to_lower() == _wanted_value.to_lower():
		label.text     = "POSZUKIWANY!!!"
		label.modulate = COLOR_WANTED
	else:
		label.text     = "Brak danych..."
		label.modulate = COLOR_NORMAL

# ---------------------------------------------------------------
func _reset_labels() -> void:
	label_id.text       = "Brak danych..."
	label_id.modulate   = COLOR_NORMAL
	label_name.text     = "Brak danych..."
	label_name.modulate = COLOR_NORMAL
