extends Node


var path_to_data = "res://assets/resources/airport.json"
var file = FileAccess.open(path_to_data, FileAccess.READ)
var data = JSON.parse_string(file.get_as_text())

var option:Array		= ["male", "female", "neutral"]

func _ready() -> void:
	var npc_list:Array		= random_npc_data()
	var anomalys_list:Array	= anomaly(npc_list)
	print(npc_list)
	print("================================")
	print(anomalys_list)

func random_npc_data() -> Array:
	var npc:Array
	
	for i in range(10):
		var person:Dictionary 
		var category:String = option.pick_random()
		var list:Array  	= data["names"][category]
		person["name"]  	= list.pick_random()

		list 				= data["surnames"]
		person["surname"]	= list.pick_random()
		person["id"]		= randi_range(10000000, 99999999)
		person["debugId"]	= i

		npc.append(person)
	
	return npc

func anomaly(original:Array) -> Array:
	var anomaly_list:Array	= []
	var size:int		= original.size()
	var percent:int		= floor(randf_range(0.1, 0.4) * size)
	
	for anomaly_char in range(percent):
		var character:Dictionary = original.pick_random().duplicate(true)
		var options:Array = ["names", "surnames", "id"]
		
		for anomalies in randi_range(1, 4):
			var selector = options.pick_random()
			
			if selector == "names":
				var mutation:Array = data["names"]["neutral"]
				character["name"] = mutation.pick_random()
			elif selector == "surnames":
				var mutation:Array = data["surnames"]
				character["surname"] = mutation.pick_random()
			else:
				character["id"] = randi_range(10000000, 99999999)
				
		anomaly_list.append(character)
	
	return	anomaly_list
