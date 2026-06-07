extends CharacterBody2D

const LANES = [725.0, 890.0, 1080.0, 1245.0]

var current_lane = 3

func _ready() -> void:
	global_position.x = LANES[current_lane]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		if current_lane - 1 >= 0: 
			current_lane -= 1
	
	if event.is_action_pressed("ui_right"):
		if current_lane + 1 <= 3: 
			current_lane += 1
	
	change_smooth_line()

func change_smooth_line() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position",Vector2(LANES[current_lane], self.position.y), 0.3)
