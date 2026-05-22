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
var truth_table:Dictionary
var debug:		int 
#endregion

#region ZmiennePlików
var _path_to_data 	= "res://assets/resources/person_data.json"
var _data_file 		= FileAccess.open(_path_to_data, FileAccess.READ)
var _data:Dictionary= JSON.parse_string(_data_file.get_as_text())
var _option:Array	= ["male", "female", "neutral"]
#endregion

#region FunkcjeGłówne

var category:String


func generate_npc() -> void:
		category = _option.pick_random()
		name = _data["names"][category].pick_random()
		surname	= _data["surnames"].pick_random()
		
		var year	= randi_range(1970, 2005)
		var month	= randi_range(1, 12)
		var day		= randi_range(1, 28)
		bday		=  "%d.%d.%d" % [day, month, year]

		id		= _caesar(name, surname, bday)
		anomalies	= _anomaly()
		img = _image(category)
		truth_table = gen_truth_table()
#endregion

#region FunkcjePomocnicze

@warning_ignore("shadowed_variable")
func _image(category:String) -> String:
	var path = "res://assets/assets/airport-sec/npc" 
	var img_path = ""
	var img_list: PackedStringArray
	var correct_imgs: Array[String] = []
	
	if category == 'male' || category == 'female':
		path += "/%s" % category
	else:
		path += "/%s" % ["male", "female"].pick_random()
			
	var dir = DirAccess.open(path)
	if dir:
		img_list = dir.get_files() 
		
		if !img_list.is_empty():
			for f in img_list:
				if f.ends_with(".png") or f.ends_with(".png.remap") or f.ends_with(".png.import"):
					var clean_name = f.replace(".remap", "").replace(".import", "")
					if not correct_imgs.has(clean_name):
						correct_imgs.append(clean_name)
						
			if not correct_imgs.is_empty():
				img_path = "%s/%s" % [path, correct_imgs.pick_random()]
				
	if img_path == "":
		print("KRYTYCZNY BŁĄD: Nie znaleziono żadnego obrazka w: ", path)
		
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
	var result_list: Array = []
	var pool: Array = ["name", "surname", "id", "bday", "img", "wanted"]
	if randf() < 0.55:
		var count = randi_range(1, pool.size() + 1) # Zmieniono na 1-2, żeby nie slice'ować 0
		pool.shuffle()
		result_list = pool.slice(0, count)
	return result_list
	
#endregion

#region AnomalyFunctions

func wrong_name() -> String:
	var all_names: Array = _data["names"][category]
	var filtered_names = all_names.filter(func(n): return n != name)
	return filtered_names.pick_random()
	
func wrong_surname() -> String:
	var all_surnames = _data["surnames"]
	var filtered_surnames = all_surnames.filter(func(s): return s != surname)
	return filtered_surnames.pick_random()
	
func wrong_id() -> String: 
	return id.substr(0, id.length() - 1) + str(randi_range(0,9)) + "X"

func wrong_img() -> String:
	var path = "res://assets/assets/airport-sec/npc/"
	if category == 'male' || category == 'female':
		path += category
	else:
		path = img.get_base_dir()
	
	var dir = DirAccess.open(path)
	if not dir:
		return img
		
	var all_files = dir.get_files()
	var valid_imgs: Array[String] = []
	
	for f in all_files:
		if f.ends_with(".png") or f.ends_with(".png.remap") or f.ends_with(".png.import"):
			var clean_name = f.replace(".remap", "").replace(".import", "")
			var full_path = path + "/" + clean_name
			
			if full_path != img and not valid_imgs.has(full_path):
				valid_imgs.append(full_path)
	
	if valid_imgs.is_empty():
		return img 
		
	return valid_imgs.pick_random()

func wrong_bday() -> String:
	var new_bday = ""
	while true:
		var year = randi_range(1970, 2005)
		var month = randi_range(1, 12)
		var day = randi_range(1, 28)
		new_bday = "%d.%d.%d" % [day, month, year]
		if new_bday != bday:
			break
	return new_bday

#endregion

func gen_truth_table() -> Dictionary:
	var dict = {
		"name": anomalies.has("name"),      # true = jest błąd
		"surname": anomalies.has("surname"),
		"img": anomalies.has("img"),
		"bday": anomalies.has("bday"),
		"id": anomalies.has("id"),
		"wanted": anomalies.has("wanted")
	}
	return dict
