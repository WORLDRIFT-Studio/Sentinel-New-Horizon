extends Camera2D

@export_category("Camera settings")
@export_group("Map Limits")
@export var map_limit_left: int = 0
@export var map_limit_right: int = 2000
@export var map_limit_top: int = 0
@export var map_limit_bottom: int = 2000
@export_group("")
@export var speed = 600.0

func _process(delta: float) -> void:
	var move_input = Input.get_vector("Left", "Right", "Up", "Down")
	
	var new_pos = position + (move_input * speed * delta)	    
	position = clamp_position(new_pos)


func clamp_position(target_pos: Vector2) -> Vector2:
	var view_size = get_viewport_rect().size / zoom
	var half_view = view_size / 2.0
	
	var min_x = map_limit_left + half_view.x
	var max_x = map_limit_right - half_view.x
	var min_y = map_limit_top + half_view.y
	var max_y = map_limit_bottom - half_view.y
	
	if max_x < min_x:
		target_pos.x = (map_limit_left + map_limit_right) / 2.0
	else:
		target_pos.x = clamp(target_pos.x, min_x, max_x)
		
	if max_y < min_y:
		target_pos.y = (map_limit_top + map_limit_bottom) / 2.0
	else:
		target_pos.y = clamp(target_pos.y, min_y, max_y)
		
	return target_pos
