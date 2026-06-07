extends Area2D

var speed = 300.0

func _process(delta):
	position.y += speed * delta
	
	var screen_height = get_viewport().get_visible_rect().size.y
	if position.y > screen_height + 100:
		queue_free()

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Ambulance":
		body.get_parent()._fuel_restored()
		queue_free()
