extends Camera2D
@export var SLIDE_SPEED: float

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ScrollIn"):
		if zoom < Vector2(1.5, 1.5):
			zoom += Vector2(0.05, 0.05)
		return
		
	if Input.is_action_just_pressed("ScrollOut"):
		if zoom > Vector2(0.6, 0.6):
			zoom -= Vector2(0.05, 0.05)
		return
	
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	position += direction * delta * SLIDE_SPEED
