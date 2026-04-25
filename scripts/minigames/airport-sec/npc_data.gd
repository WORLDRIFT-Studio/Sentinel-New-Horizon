# Kod wspomagany AI
# ================= 
# Klasa dla NPC

class_name NPC
extends Resource


#region DaneNPC
var img:		String
var name:		String
var surname:	String
var bday:		String
var id:			String
var anomalies:	Array
var debug:		int
var is_wanted:  bool      # NOWE
var wanted_by:  String    # NOWE
#endregion

#region ZmiennePlików
var _path_to_data 	= "res://assets/resources/person_data.json"
var _data_file 		= FileAccess.open(_path_to_data, FileAccess.READ)
var _data 			= JSON.parse_string(_data_file.get_as_text())
var _anomalies_file = FileAccess.open("res://assets/resources/anomalies.json", FileAccess.READ)
var _anomalies:Array = JSON.parse_string(_anomalies_file.get_as_text())
var _option:Array	= ["male", "female", "neutral"]
#endregion

#region FunkcjeGłówne

func string() -> String:
	return "NPC %s %s, bday: %s, id: %s, anomalies: %s" % [
		name, surname, bday, id, anomalies
	]
	
func generate_npc() -> void:
		var category:String = _option.pick_random()
		name = _data["names"][category].pick_random()
		surname	= _data["surnames"].pick_random()
		
		var year	= randi_range(1970, 2005)
		var month	= randi_range(1, 12)
		var day		= randi_range(1, 28)
		bday		=  "%d.%d.%d" % [day, month, year]

		id		= _caesar(name, surname, bday)
		anomalies	= _anomaly()
		img = _image(category)
		#====================================NOWE====================================#
		is_wanted = randf() < 0.10
		if is_wanted:
			wanted_by = ["name", "id"].pick_random()
#endregion

#region FunkcjePomocnicze

func _image(category:String) -> String:
	var path = "res://assets/assets/airport-sec/npc" 
	var img_path = ""
	var img_list:PackedStringArray
	var correct_imgs:Array[String] = []
	if category == 'male' || category == 'female':
		path += "/%s" % category
	else:
		path += "/%s" % ["male", "female"].pick_random()
			
	var file = DirAccess
	file = DirAccess.open(path)
	img_list = file.get_files() 
	
	if !img_list.is_empty():
		for f in img_list:
			pass
			if f.ends_with(".png"):
				correct_imgs.append(f)
		img_path = "%s/%s" % [path, correct_imgs.pick_random()]
	return img_path

func _caesar(first:String, second:String, npc_id:String) -> String:
	var shift:int		= int(npc_id[0]) # izoluje przesuniecie z ID
	var f_char:String	= first[0].to_upper() 
	var s_char:String	= second[0].to_upper()	
	var output:String	= char((ord(f_char) - 65 + shift) % 26 + 65) + \
						  char((ord(s_char) - 65 + shift) % 26 + 65) # Szyfratort
	output += str(shift)
	
	var id_code:String = str(randi_range(0, 99999))
	id_code = id_code.pad_zeros(5)
	output += id_code # dopełnienie zerami od prawej do 5 cyfr
	
	return output
	
func _anomaly() -> Array:
		var list:Array = []
		var pool:Array = _anomalies
		if randf() < 0.35:
			var cards = randi_range(0, 3)
			pool.shuffle()
			list = pool.slice(0, cards)
		return list
#endregion
