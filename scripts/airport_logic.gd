extends Node


var path_to_data = "res://assets/resources/airport.json"
var file = FileAccess.open(path_to_data, FileAccess.READ)
var data = JSON.parse_string(file.get_as_text())


func random_npc_data() -> void:
	var option:Array		= ["male", "female", "neutral"]
	var npc:Array
	
	for i in range(10):
		var person:Dictionary 
		var category:String = option.pick_random()
		var list:Array  	= data["names"][category]
		person["name"]  	= list.pick_random()
		
		list 				= data["surnames"]
		person["surname"]	= list.pick_random()
		person["id"]		= randi_range(10000000, 99999999)

		npc.append(person)
		
