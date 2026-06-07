#Kod napisany przez Gemini
extends Control

var fuel_percent: float = 1.0
var _tween: Tween

func _draw():
	var cx = size.x / 2
	var cy = size.y
	var r = size.x * 0.42
	var thickness = 40.0
	var outline_size = 4.0
	var half = thickness / 2.0
	var half_out = half + outline_size
	
	var start_angle = PI
	var full_end_angle = TAU
	
	var start_pt = Vector2(cx + cos(start_angle) * r, cy + sin(start_angle) * r)
	var full_end_pt = Vector2(cx + cos(full_end_angle) * r, cy + sin(full_end_angle) * r)
	
	var outline_color = Color(0.0, 0.0, 0.0, 1.0)
	var bg_color = Color(0.2, 0.2, 0.2)
	
	# --- 1. KOMPLETNA OBWÓDKA ---
	draw_arc(Vector2(cx, cy), r, start_angle, full_end_angle, 64, outline_color, thickness + outline_size * 2, true)
	draw_circle(start_pt, half_out, outline_color, true, -1.0, true)
	draw_circle(full_end_pt, half_out, outline_color, true, -1.0, true)
	
	# --- 2. TŁO WSKAŹNIKA ---
	draw_arc(Vector2(cx, cy), r, start_angle, full_end_angle, 64, bg_color, thickness, true)
	draw_circle(start_pt, half, bg_color, true, -1.0, true)
	draw_circle(full_end_pt, half, bg_color, true, -1.0, true)
	
	# --- 3. WŁAŚCIWY PASEK PALIWA ---
	if fuel_percent > 0.0:
		var fuel_end_angle = start_angle + fuel_percent * PI
		var fuel_end_pt = Vector2(cx + cos(fuel_end_angle) * r, cy + sin(fuel_end_angle) * r)
		
		var color = Color(0.2, 0.85, 0.2).lerp(Color(0.9, 0.15, 0.15), 1.0 - fuel_percent)
		
		draw_arc(Vector2(cx, cy), r, start_angle, fuel_end_angle, 64, color, thickness, true)
		draw_circle(start_pt, half, color, true, -1.0, true)
		draw_circle(fuel_end_pt, half, color, true, -1.0, true)

func set_fuel(current: float, maximum: float):
	var target_percent = 0.0
	if maximum > 0.0:
		target_percent = clamp(current / maximum, 0.0, 1.0)
	
	if _tween and _tween.is_valid():
		_tween.kill()
		
	_tween = create_tween()
	
	# Możesz zmienić styl przejścia. TRANS_CUBIC i EASE_OUT dają ładny efekt "zwalniania" na końcu
	_tween.set_trans(Tween.TRANS_CUBIC)
	_tween.set_ease(Tween.EASE_OUT)
	
	_tween.tween_property(self, "fuel_percent", target_percent, 0.3)
	
	_tween.tween_callback(queue_redraw)

func _process(_delta):
	if _tween and _tween.is_running():
		queue_redraw()
