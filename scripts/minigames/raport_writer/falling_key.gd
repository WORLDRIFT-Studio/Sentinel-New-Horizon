extends Sprite2D

@export var fall_speed: float = 400.0
var init_y_pos: float = -360
var has_passed: bool = false
var pass_threshold = 300.0
var target_hit_time: float = 0.0

func _init():
	set_process(false)

func _process(delta):
	global_position += Vector2(0, fall_speed * delta)
	
	if global_position.y > pass_threshold and not $Timer.is_stopped():
		$Timer.stop()
		has_passed = true

func Setup(target_x: float, target_texture: Texture2D, flip_h: bool, flip_v: bool, hit_time: float):
	global_position = Vector2(target_x, init_y_pos)
	texture = target_texture
	self.flip_h = flip_h
	self.flip_v = flip_v
	target_hit_time = hit_time
	set_process(true)

func _on_destroy_timer_timeout():
	queue_free()
