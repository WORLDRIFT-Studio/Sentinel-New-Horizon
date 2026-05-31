extends Node2D

@onready var progress_bar = $ProgressBar
@export var next_scene_path: String = 'res://scenes/menu/main_menu.tscn'
var progress: Array[float] = []
var is_loading_done: bool = false

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta):
	if is_loading_done:
		return
		
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100
			progress_bar.value = pct
		ResourceLoader.THREAD_LOAD_LOADED:
			is_loading_done = true
			var tween = create_tween()
			tween.tween_property(progress_bar, "value", 100, 0.3)
			await tween.finished
			var scene = ResourceLoader.load_threaded_get(next_scene_path)
			get_tree().change_scene_to_packed(scene)
