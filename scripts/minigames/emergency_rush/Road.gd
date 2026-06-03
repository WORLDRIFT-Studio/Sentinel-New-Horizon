#Kod napisany przy pomocy Claude
extends Node2D

const scroll_speed = 400.0
const tile_height = 1113.2

@onready var tile1: Sprite2D = $RoadTile1
@onready var tile2 = $RoadTile2
@onready var tile3 = $RoadTile3

func _ready():
	print("Scale tile1: ", tile1.scale)
	print("Scale parent: ", self.scale)
	print("Rzeczywista wys.: ", tile1.get_rect().size.y * tile1.scale.y)
	tile1.position.y = 0.0
	tile2.position.y = -tile_height
	tile3.position.y = -tile_height * 2

func _process(delta):
	tile1.position.y += scroll_speed * delta
	tile2.position.y += scroll_speed * delta
	tile3.position.y += scroll_speed * delta
	
	var screen_height = get_viewport().get_visible_rect().size.y
	var threshold = screen_height + tile_height / 2

	var pos1 = tile1.position.y
	var pos2 = tile2.position.y
	var pos3 = tile3.position.y

	if pos1 > threshold:
		tile1.position.y = min(pos2, pos3) - tile_height
		print(1)

	if pos2 > threshold:
		tile2.position.y = min(pos1, pos3) - tile_height
		print(2)

	if pos3 > threshold:
		tile3.position.y = min(pos1, pos2) - tile_height
		print(3)
