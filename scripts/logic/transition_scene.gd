extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

var target_scene: String = ""

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)


func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")


func fade_to_scene(scene_path: String):
	target_scene = scene_path
	transition()
\

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		get_tree().change_scene_to_file(target_scene)
		await get_tree().process_frame
		animation_player.play("fade_to_normal")

	elif anim_name == "fade_to_normal":
		color_rect.visible = false
