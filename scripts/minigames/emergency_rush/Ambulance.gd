extends CharacterBody2D

const SPEED = 300.0
const MIN_X = 740.0
const MAX_X = 1160.0

func _physics_process(_delta):
	var direction = 0.0
	
	if Input.is_action_pressed("ui_left"):
		direction = -1.0
	elif Input.is_action_pressed("ui_right"):
		direction = 1.0
	
	velocity.x = direction * SPEED
	velocity.y = 0.0
	
	move_and_slide()
	
	position.x = clamp(position.x, MIN_X, MAX_X)
