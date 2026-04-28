# Kod wspomagany AI
# =================
# Główny skrypt Airport Security

# Clock Sound Effect by DRAGON-STUDIO from Pixabay
extends Node
@onready var panel_name: Panel = %PanelName
@onready var panel_surname: Panel = %PanelSurname
@onready var panel_img: Panel = %PanelImg
@onready var panel_bday: Panel = %PanelBday
@onready var panel_id: Panel = %PanelId
@onready var panel_wanted: Panel = %PanelWanted
@onready var chbx_container: VBoxContainer = $Control/CheckboxList/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer


#region GlobalScopeVariable

@export	var categories:PackedStringArray
var list: Array = []
var total_score: int = 0
var current_index: int = 0
var anomaly_methods:Dictionary = {
	"name": "wrong_name",
	"surname": "wrong_surname",
	"id": "wrong_id",
	"img": "wrong_img",
	"bday": "wrong_bday",
}
@export var wanted_conatiner: VBoxContainer
@export var wanted_template: PackedScene
#endregion 

#region NPC

@onready var sound_npc: AudioStreamPlayer2D = %SoundNPC

#endregion

#region AdditionalFunctions
func shuffle_list() -> void:
	var temp = wanted_conatiner.get_children()
	temp.shuffle()
	for i in range(temp.size()):
		wanted_conatiner.move_child(temp[i], i)

func gen_wanted_list() -> void:
	var number = randi_range(20, 40)
	for num in range(number):
		gen_wanted_filler()

	for npc:NPC in list:
		if npc.anomalies.has("wanted"):
			gen_wanted_anomalie(npc)
			
	shuffle_list()
			
func gen_wanted_filler() -> void:
	var data = NPC.new()
	data.generate_npc()
	var instance = wanted_template.instantiate()
	instance.get_node("%WantedName").text = data.name
	instance.get_node("%WantedSurname").text = data.surname
	instance.get_node("%WantedId").text = data.id
	instance.get_node("%WantedImg").texture = load(data.img)
	wanted_conatiner.add_child(instance)
	
	
func gen_wanted_anomalie(npc:NPC) -> void:
	var instance = wanted_template.instantiate()
	instance.get_node("%WantedName").text = npc.name
	instance.get_node("%WantedSurname").text = npc.surname
	instance.get_node("%WantedId").text = npc.id
	instance.get_node("%WantedImg").texture = load(npc.img)
	wanted_conatiner.add_child(instance)	
	
	
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
	

#endregion

#region Main
func _ready() -> void:
	#load_game_data()
	list = generate_list(10)
	gen_wanted_list()
	display_next_npc()

func _on_next_pressed() -> void:
	var npc = list[current_index]
	var player_answers = send_answers() # Pobiera Dictionary { "id": true, "name": false ... }
	
	# 1. Oblicz punkty za tego konkretnego NPC
	var points_this_round = check_single_npc(npc, player_answers)
	total_score += points_this_round
	
	print("NPC nr %d oceniony. Punkty: %d | Suma: %d" % [current_index, points_this_round, total_score])
	
	# 2. Sprawdź, czy to koniec listy
	if current_index < list.size() - 1:
		current_index += 1
		reset_ui_panel() # Funkcja czyszcząca checkboxy
		display_next_npc()
	else:
		show_final_summary()

#endregion

func send_answers() -> Dictionary:
	var answers:Dictionary = {}
	for node in  chbx_container.get_children():
		if node.get_node("%FalseBox").pressed:
			answers[node.category] = true
		else:
			answers[node.category] = false
			
	return answers
	

func show_final_summary() -> void:
	pass
	
func check_single_npc(npc: NPC, answer: Dictionary) -> int:
	var score: int = 0
	var table = npc.truth_table
	
	for option in table.keys():
		# Sprawdzamy czy to co u NPC (table[option]) zgadza się z tym co u gracza (answer[option])
		if table[option] == answer.get(option, false):
			score += 100
		else:
			score -= 150
	return score
	
func reset_ui_panel() -> void:
	for node in  chbx_container.get_children():
		node.get_node("%FalseBox").set_pressed(false)
		node.get_node("%TrueBox").set_pressed(false)


var time_left: float = 15.0 # Czas w sekundach
var game_over: bool = false
var clock_played: bool = false
var timer: float = 0.0


func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		_update_timer_label()
	elif not game_over:
		game_over = true
		_time_is_up()
	if time_left <= 8 and clock_played == false:
		%Clock.play()
		clock_played = true
		
	if time_left <= 8.0: # Miganie włącza się poniżej 8 sekund
		timer += delta
		# floor(timer * 2) zmienia wartość co 0.5 sekundy (cykl 1s: biały -> czerwony)
		if int(timer * 2) % 2 == 0:
			%TimerLabel.modulate = Color.WHITE
		else:
			%TimerLabel.modulate = Color.RED
	else:
		%TimerLabel.modulate = Color.WHITE # Reset do białego powyżej 8s
	
	
func _update_timer_label() -> void:
	# Formatowanie sekund na MM:SS
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	%TimerLabel.text = "%02d:%02d" % [minutes, seconds]
		


func _time_is_up() -> void:
	print("Czas minął!")
	# Wywołaj podsumowanie wyników
