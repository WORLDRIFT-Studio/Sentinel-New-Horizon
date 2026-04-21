# Kod wspomagany AI
# =================
# Główny skrypt Airport Security

extends Node

var anomaly_methods:Dictionary = {
	"name": "wrong_name",
	"surname": "wrong_surname",
	"id": "wrong_id",
	"img": "wrong_img",
	"bday": "wrong_bday"
}

#region GlobalScopeVariable

@export	var categories:PackedStringArray
var list: Array = []
var current_index: int = 0
var playerAccept: Array = []
var playerReject: Array = []
var accept: Array = []
var reject: Array = []

#endregion 

#region NPC

@onready var sound_npc: AudioStreamPlayer2D = %SoundNPC

#endregion

#region AdditionalFunctions

func load_anomalies(character: NPC, category: String, group: Array) -> void:
	if category in character.anomalies and anomaly_methods.has(category):
		if group.is_empty(): 
			return
			
		var node = group.pick_random()
		if category != "img":
			if character.has_method(anomaly_methods[category]):
				var ntext = character.call(anomaly_methods[category])
				node.text = str(ntext)
				
		if category == "img":
			if character.has_method(anomaly_methods[category]):
				node.texture = load(character.call(anomaly_methods["img"]))

func display_next_npc() -> void:
	var npc: NPC = list[current_index]
	
	for category in categories:
		load_category(npc, category)

func last_npc() -> void:
	
	pass

func generate_list(count: int) -> Array:
	var npc_list: Array = []
	for i in range(count):
		var npc = NPC.new()
		npc.generate_npc()
		npc.debug = i
		npc_list.append(npc)
	return npc_list

func load_category(character:NPC, category:Variant) -> void:
	var group_nodes:Array[Node] = []

	group_nodes = get_tree().get_nodes_in_group(category)
		
	if category == 'img':
		for node in group_nodes:
			node.texture = load(character.img)
	else:
		for node in group_nodes:
			node.text = character.get(category)
	
	load_anomalies(character, category, group_nodes)

func return_npc() -> NPC:
	var npc:NPC = list[current_index]
	return npc
	
func process_decision(is_accsepted:bool) -> void:
	if is_accsepted:
		playerAccept.append(current_index)
	else:
		playerReject.append(current_index)
		
	if current_index >= list.size() - 1:
		#_show_end_game_popup()
		pass
	else:
		current_index += 1
		display_next_npc()
#endregion


func _ready() -> void:
	#load_game_data()
	list = generate_list(10)
	display_next_npc()

func _on_accept_pressed() -> void:
	current_index += 1
	playerAccept.append(current_index)
	display_next_npc()
	

func _on_reject_pressed() -> void:
	if current_index % list.size() == 1:
		pass
	else:
		current_index += 1 		
		playerReject.append(current_index)
		display_next_npc()
