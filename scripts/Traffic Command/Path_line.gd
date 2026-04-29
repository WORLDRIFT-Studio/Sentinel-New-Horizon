extends Path2D

var line: Line2D

func _ready() -> void:
	line = Line2D.new()
	add_child(line)
	
	line.width = 6.0
	line.default_color = Color(0.0, 0.835, 0.161, 1.0)
	line.z_index = 1
	
	var points = curve.get_baked_points()
	for point in points:
		line.add_point(point)
	
	line.visible = false

func show_path() -> void:
	line.visible = true

func hide_path() -> void:
	line.visible = false
