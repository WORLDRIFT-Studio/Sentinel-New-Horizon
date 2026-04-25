# Kod wspomagany AI
# =================
# Główny skrypt Airport Security

extends Node

#region GlobalScopeVariable

@export	var categories:PackedStringArray
var list: Array = []
var current_index: int = 0
var playerAccept: Array
var playerReject: Array
var accept: Array
var reject: Array

#endregion 

#region NPC

@onready var sound_npc: AudioStreamPlayer2D = %SoundNPC

#endregion

#region Document

@onready var img_document: TextureRect = %ImgDocument
@onready var name_document: Label = %NameDocument
@onready var surname_document: Label = %SurnameDocument
@onready var bday_document: Label = %BdayDocument
@onready var id_document: Label = %IdDocument

#endregion

#region Passport

@onready var img_passport: TextureRect = %ImgPassport
@onready var name_pasport: Label = %NamePassport
@onready var surname_pasport: Label = %SurnamePassport
@onready var id_pasport: Label = %IdPassport

#endregion

#region AdditionalFunctions

func display_next_npc() -> void:
	var npc: NPC = list[current_index]
	for category in categories:
		_load_category(npc, category)
	
func generate_list(count: int) -> Array:
	var npc_list: Array = []
	for i in range(count):
		var npc = NPC.new()
		npc.generate_npc()
		npc.debug = i
		npc_list.append(npc)
	return npc_list

func _load_category(character:NPC, category:Variant) -> void:
	var group_nodes:Array[Node]
	group_nodes = get_tree().get_nodes_in_group(category)
	if category == 'img':
		for node in group_nodes:
			node.texture = load(character.img)
	else:
		for node in group_nodes:
			node.text = character.get(category)
	
func _return_npc() -> NPC:
	var npc:NPC = list[current_index]
	return npc
#endregion


func _ready() -> void:
	#load_game_data()
	list = generate_list(10)
	display_next_npc()

func _on_accept_pressed() -> void:
	current_index = (current_index + 1) % list.size()
	playerAccept.append(current_index)
	display_next_npc()


func _on_reject_pressed() -> void:
	current_index = (current_index + 1) % list.size()
	playerReject.append(current_index)
	display_next_npc()

#============================NOWE==================================#
@onready var wanted_panel = $Control/Wanted  # ścieżka do Listów gończych. I guess

func _on_new_npc_spawned() -> void:
	var npc = NPC.new()
	npc.generate_npc()
	wanted_panel.load_npc(npc)   # przekazujesz gotowego typka do panelu
