extends Node

var progress_bar: ProgressBar
var progress = 0.0
var elapsed = 0.0
const MIN_TIME = 5.0

func _ready():
	progress_bar = get_node_or_null("ProgressBar")
	if progress_bar == null:
		progress_bar = get_node_or_null("../ProgressBar")
	if progress_bar == null:
		progress_bar = get_node_or_null("/root/loading/ProgressBar")
	
	if progress_bar == null:
		push_error("ProgressBar node not found!")

func _process(delta):
	if progress_bar == null:
		return 

	elapsed += delta

	if progress < 100.0:
		progress = minf(progress + delta * 20.0, 100.0)  
		progress_bar.value = progress
	elif elapsed >= MIN_TIME:
		TransitionScene.fade_to_scene("res://scenes/menu/main_menu.tscn")
