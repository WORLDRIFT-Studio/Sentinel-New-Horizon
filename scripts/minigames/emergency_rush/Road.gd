extends Node2D

var scroll_speed = 300.0
var tile_height = 768.0

@onready var tile1 = $RoadTile1
@onready var tile2 = $RoadTile2

func _ready():
	tile1.position.y = 0.0
	tile2.position.y = -tile_height

func _process(delta):
	tile1.position.y += scroll_speed * delta
	tile2.position.y += scroll_speed * delta
	
	var screen_height = get_viewport().get_visible_rect().size.y
	
	if tile1.position.y > screen_height + tile_height / 2:
		tile1.position.y = tile2.position.y - tile_height
	
	if tile2.position.y > screen_height + tile_height / 2:
		tile2.position.y = tile1.position.y - tile_height
