extends Camera2D
@export var SLIDE_SPEED: float

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ScrollIn"):
		if zoom < Vector2(2.0, 1.0):
			zoom += Vector2(0.05, 0.05)
		return
		
	if Input.is_action_just_pressed("ScrollOut"):
		if zoom > Vector2(1.0, 1.0):
			zoom -= Vector2(0.05, 0.05)
		return

	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	var target = position + direction * SLIDE_SPEED * delta
	
	target.x = clamp(target.x, limit_left, limit_right)
	target.y = clamp(target.y, limit_top, limit_bottom)
	
	position = position.move_toward(target, SLIDE_SPEED * delta)
