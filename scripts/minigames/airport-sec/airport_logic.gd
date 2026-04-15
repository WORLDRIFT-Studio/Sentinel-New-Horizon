# Kod wspomagany AI
# =================
# Główny skrypt Airport Security

extends Node

var anomaly_methods:Dictionary = {
	"name": "wrong_name",
	"surname": "wrong_surname",
	"id": "wrong_id"
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

func display_next_npc() -> void:
	var npc: NPC = list[current_index]
	for category in categories:
		load_category(npc, category)
	
func generate_list(count: int) -> Array:
	var npc_list: Array = []
	for i in range(count):
		var npc = NPC.new()
		npc.generate_npc()
		npc.debug = i
		npc_list.append(npc)
	return npc_list

func load_category(character:NPC, category:Variant, last:bool = false) -> void:
	var group_nodes:Array[Node] = []
	if not last:
		group_nodes = get_tree().get_nodes_in_group(category)
			
		if category == 'img':
			for node in group_nodes:
				node.texture = load(character.img)
		else:
			for node in group_nodes:
				node.text = character.get(category)
		
		load_anomalies(character, category, group_nodes)
	else:
		pass
		
		
					
		
func return_npc() -> NPC:
	var npc:NPC = list[current_index]
	return npc
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
	current_index += 1 
	if list[current_index] == list[-1]:
		pass
	playerReject.append(current_index)
	display_next_npc()

func load_anomalies(character: NPC, category: String, group: Array) -> void:
	if category in character.anomalies and anomaly_methods.has(category):
		if group.is_empty(): 
			return
			
		var node = group.pick_random()
		if category != "img":
			if character.has_method(anomaly_methods[category]):
				var ntext = character.call(anomaly_methods[category])
				node.text = str(ntext)
