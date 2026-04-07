extends Node

@onready var character_1:	OptionButton 	= $Character1
@onready var checker:		OptionButton 	= $Checker
@onready var character_2:	OptionButton 	= $Character2
@onready var correct_name: 	Label			= $CorrectName
@onready var incorrect_name_2: 	Label 		= $IncorrectName2
@onready var button: 			Button		= $Button


#region zmienne
var path_to_data = "res://assets/resources/person_data.json"
var data_file = FileAccess.open(path_to_data, FileAccess.READ)
var data = JSON.parse_string(data_file.get_as_text())

var anomalies_file = FileAccess.open("res://assets/resources/anomalies.json", FileAccess.READ)
var anomalies:Array = JSON.parse_string(anomalies_file.get_as_text())
#endregion

var option:Array		= ["male", "female", "neutral"]
var npc_list:Array

func _ready() -> void:
	npc_list		= random_npc_data()
	for npc in npc_list:
		var text = "name: %s\n surname: %s\n id: %s" % [npc["name"], npc["surname"], npc["id"]]
		character_1.add_item(text)	
		print(npc)
	
func random_npc_data() -> Array[Dictionary]:
	var npc:Array[Dictionary]
	
	for i in range(10):
		var person:Dictionary 
		var category:String = option.pick_random()
		var names:Array	= data["names"][category]
		person["name"]  	= names.pick_random()

		var surnames:Array	= data["surnames"]
		surnames 				= data["surnames"]
		person["surname"]	= surnames.pick_random()
		
		var year	= randi_range(1970, 2005)
		var month	= randi_range(1, 12)
		var day		= randi_range(1, 28)
		person["bday"]		=  "%d.%d.%d" % [day, month, year]

		person["id"]		= caesar(person["name"], person["surname"], person["bday"])
		person["anomalies"]	= anomaly()
		person["key"]	= i

		npc.append(person)
	
	return npc

func anomaly() -> Array:
	var list:Array = []
	var pool:Array = anomalies
	if randf() < 0.35:
		var cards = randi_range(0, 3)
		pool.shuffle()
		list = pool.slice(0, cards)
		
	return list

func caesar(first:String, second:String, id:String) -> String:
	var shift:int		= int(id[0]) # izoluje przesuniecie z ID
	var f_char:String	= first[0].to_upper() 
	var s_char:String	= second[0].to_upper()	
	var output:String	= char((ord(f_char) - 65 + shift) % 26 + 65) + \
						  char((ord(s_char) - 65 + shift) % 26 + 65) # Szyfratort
	output += str(shift)
	
	var id_code:String = str(randi_range(0, 99999))
	id_code = id_code.pad_zeros(5)
	output += id_code # dopełnienie zerami od prawej do 5 cyfr
	
	return output	

func anomaly_manager(character:Dictionary) -> void:
	var text = "name: %s\nsurname: %s\nbirth day:%s\nid: %s" % [character["name"], character["surname"],character["bday"], character["id"]]
	correct_name.text = text
	
func _on_button_pressed() -> void:
	var x = 0
	var char = npc_list[x]	
	anomaly_manager(char)
	x += 1
