extends LineEdit

@export var no_data:Label
@export var childrens_parent:Node

func _on_text_changed(new_text: String) -> void:
	new_text.to_lower()
	
	if new_text == "":
		for child in childrens_parent.get_children():
			child.visible = true
	
	else:
		for child in childrens_parent.get_children():
			var label = child.get_node("MarginContainer/HBoxContainer/Label")
			var option_text = label.text.to_lower()
			
			child.visible = option_text.contains(new_text)
			
	var any_visible = false
	
	for child in childrens_parent.get_children():
		if child.visible:
			any_visible = true

	no_data.visible = !any_visible

			
