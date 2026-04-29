# Kod wspomagany AI
# =================
# Skrypt wyszuwkiwarki

extends LineEdit

@export var no_data: Label           # Label "Brak wyników"
@export var childrens_parent: Node    # VBoxContainer z wpisami

func _on_text_changed(new_text: String) -> void:
	var search_term = new_text.strip_edges().to_lower()
	
	if search_term == "":
		_set_all_visible(true)
		no_data.visible = false
		return

	var any_visible = false

	for child in childrens_parent.get_children():
		var is_match = _check_match(child, search_term)
		child.visible = is_match
		
		if is_match:
			any_visible = true

	no_data.visible = !any_visible

func _check_match(item: Node, term: String) -> bool:
	for label in item.find_children("*", "Label", true, false):
		if label.text.to_lower().contains(term):
			return true
			
	return false
# Skrytpt wyszukwiarki

func _set_all_visible(state: bool) -> void:
	for child in childrens_parent.get_children():
		child.visible = state
