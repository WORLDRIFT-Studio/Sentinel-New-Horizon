extends Node

func _ready():
	update_label()

func update_label():
	$Label.text = "rep: " + str(GlobalData.scores / 1000)
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Wypisywanie reputacji^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
