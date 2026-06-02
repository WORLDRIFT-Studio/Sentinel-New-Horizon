# Kod wspomagany AI
# =================
# Główny skrypt Airport Security

# Clock Sound Effect by DRAGON-STUDIO from Pixaba2y
# Butons Sound Effect by freesound_community from Pixabay
# Theme Music by SunoAi
# Fanfare Sound Effect by Benjamin Adams from Pixabay


extends Node
@onready var panel_name: Panel = %PanelName
@onready var panel_surname: Panel = %PanelSurname
@onready var panel_img: Panel = %PanelImg
@onready var panel_bday: Panel = %PanelBday
@onready var panel_id: Panel = %PanelId
@onready var panel_wanted: Panel = %PanelWanted
@onready var chbx_container: VBoxContainer = $Control/CheckboxList/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

# Referencje label
@onready var time_bonus_value: Label = %TimeBonusValue
@onready var stats_value: Label = %StatsValue
@onready var grade_value: Label = %GradeValue
@onready var total_value: Label = %TotalValue


# Referencje do elementów tutorialu
@onready var arrow1: Node = $arrow1
@onready var arrow2: Node = $arrow2
@onready var arrow3: Node = $arrow3
@onready var arrow4: Node = $arrow4
@onready var buttons_panel: Node = $Control/Buttons
@onready var timer_node: Node = $Control/Timer
@onready var tutor_txt: Label = $Control/Panel/tutor_txt
@onready var summary: Panel = %Summary
@onready var animation_player: AnimationPlayer = %AnimationPlayer

#region GlobalScopeVariable
# Zmienne zegara
@export var time_left: float = 15.0 # Czas w sekundach
var game_over: bool = false
var clock_played: bool = false
var timer: float = 0.0


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

# Stats
var checked: int = 0
var perfect: int = 0
var fanfare_played: bool = false
var points: int = 0

# Tutorial
var tutorial_step: int = 0
var is_tutorial: bool = false
#endregion 

#region NPC

@onready var sound_npc: AudioStreamPlayer2D = %SoundNPC

#endregion

#region Tutorial

func _is_first_run() -> bool:
	return not GlobalData.has_completed_tutorial()

func start_tutorial() -> void:
	is_tutorial = true
	tutorial_step = 0

	# Ukryj wszystkie strzałki
	arrow1.visible = false
	arrow2.visible = false
	arrow3.visible = false
	arrow4.visible = false

	# Wyłącz przyciski i timer
	buttons_panel.visible = false
	timer_node.visible = false

	# Zatrzymaj odliczanie czasu
	set_process(false)
	
	tutor_txt.mouse_filter = Control.MOUSE_FILTER_STOP

	# Pokaż pole tutoriala i ustaw tekst
	tutor_txt.visible = true
	tutor_txt.text = "Witaj w sekcji szkoleniowej airport-security. Aby rozpocząć szkolenie kliknij w pokazany tekst."

	# Podłącz sygnał kliknięcia (jeden raz)
	if not tutor_txt.gui_input.is_connected(_on_tutor_txt_clicked):
		tutor_txt.gui_input.connect(_on_tutor_txt_clicked)

func _on_tutor_txt_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_advance_tutorial()

func _advance_tutorial() -> void:
	tutorial_step += 1

	match tutorial_step:
		1:
			arrow1.visible = true
			tutor_txt.text = "To jest twoja lista rzeczy, które musisz sprawdzić oraz dobrze zdefiniować. UWAŻAJ, gdyż właśnie z tej listy będziesz rozliczany."

		2:
			arrow1.visible = false
			arrow2.visible = true
			arrow3.visible = true
			tutor_txt.text = "To jest dowód oraz paszport aktualnie sprawdzanego człowieka. To stąd będziesz brał większość informacji. Lepiej sprawdzić oba, gdyż niektóre dane mogą się ze sobą nie zgadzać."

		3:
			arrow2.visible = false
			arrow3.visible = false
			arrow4.visible = true
			tutor_txt.text = "To jest lista poszukiwanych. Tutaj sprawdzisz, czy dana osoba nie jest ścigana przez policję. Jeżeli jest, zarejestruj to na swojej liście."

		4:
			arrow4.visible = false
			tutor_txt.text = "To już wszystko co musisz wiedzieć. Powodzenia!"

		5:
			# Koniec tutorialu — zapisz i przeładuj scenę
			GlobalData.set_tutorial_completed()
			tutor_txt.gui_input.disconnect(_on_tutor_txt_clicked)
			get_tree().reload_current_scene()

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
	
	%NPCLeft.text = "Pozostało do sprawdzenia: %02d" % (len(list) - current_index)
	print((len(list) - current_index))
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
			var tex = load(character.img)
			print(tex)
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
	# Ukryj wszystkie strzałki na starcie (zawsze)
	arrow1.visible = false
	arrow2.visible = false
	arrow3.visible = false
	arrow4.visible = false

	list = generate_list(10)
	gen_wanted_list()
	display_next_npc()

	# Sprawdź czy to pierwsze uruchomienie
	if _is_first_run():
		start_tutorial()

func _on_next_pressed() -> void:
	var npc = list[current_index]
	var player_answers = send_answers() # Pobiera Dictionary { "id": true, "name": false ... }
	# 1. Oblicz punkty za tego konkretnego NPC
	var points_this_round = check_single_npc(npc, player_answers)
	total_score += points_this_round
	
	
	# 2. Sprawdź, czy to koniec listy
	if current_index < list.size() - 1:
		current_index += 1
		reset_ui_panel() # Funkcja czyszcząca checkboxy
		display_next_npc()
	else:
		points = show_final_summary()
		animation_player.play("PanelShowUp")
		print("Play test")

#endregion

func send_answers() -> Dictionary:
	var answers:Dictionary = {}
	for node in  chbx_container.get_children():
		if node.get_node("%FalseBox").button_pressed == true:
			answers[node.category] = false
		else:
			answers[node.category] = true
			
	return answers
	
func show_final_summary() -> int:
	get_tree().paused = true
	
	# --- OBLICZENIA ---
	var time_bonus = int(max(0, time_left * 10))
	var final_score = total_score + time_bonus
	
	# Obliczanie skuteczności (procentowej)
	var total_decisions = checked * 6 # 6 kategorii na każdego NPC
	var accuracy = 0.0
	if total_decisions > 0:
		# total_score zawiera punkty dodatnie i ujemne, 
		# ale dla statystyki "skuteczności" lepiej pokazać po prostu trafienia
		accuracy = (float(perfect) / checked) * 100 if checked > 0 else 0.0
	# --- PRZYGOTOWANIE TEKSTÓW ---
	time_bonus_value.text = "PREMIA ZA CZAS: +" + str(time_bonus)
	
	# Statystyki szczegółowe
	stats_value.text = (
		"RAPORT SŁUŻBY:\n" +
		"Odprawieni pasażerowie: " + str(checked) + "\n" +
		"Bezbłędne kontrole: " + str(perfect) + "\n" +
		"Skuteczność profilowania: " + str(int(accuracy)) + "%"
	)
	
	# Komentarz zwrotny zależny od punktów
	var evaluation = ""
	if final_score > 5600: evaluation = "STATUS: EKSPERT BEZPIECZEŃSTWA"
	elif final_score > 0: evaluation = "STATUS: KONTROLER ZATWIERDZONY"
	else: evaluation = "STATUS: DO PONOWNEGO SZKOLENIA"
	
	grade_value.text = evaluation
	total_value.text = "SUMA PUNKTÓW: 0"
	
	animation_player.play("PanelShowUp")

	return final_score

func check_single_npc(npc: NPC, answer: Dictionary) -> int:
	var score: int = 0
	var table = npc.truth_table
	
	for option in table.keys():
		# Sprawdzamy czy to co u NPC (table[option]) zgadza się z tym co u gracza (answer[option])
		if table[option] == answer.get(option, false):
			score += 100
		else:
			score -= 150
	checked += 1
	if score == 600: perfect += 1
	return score
	
func reset_ui_panel() -> void:
	for node in  chbx_container.get_children():
		node.get_node("%FalseBox").set_pressed(false)
		node.get_node("%TrueBox").set_pressed(false)

#region Zegary

func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		_update_timer_label()
	elif not game_over:
		game_over = true
		_time_is_up()
	if time_left <= 8 and clock_played == false:
		clock_played = true
		%Clock.play()
		
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
	@warning_ignore("integer_division")
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	%TimerLabel.text = "%02d:%02d" % [minutes, seconds]
	
func _time_is_up() -> void:
	print("Czas minął! Kończę rundę...")
	
	if %Clock.is_playing():
		%Clock.stop()
	
	chbx_container.propagate_call("set_disabled", [true])
	
	points = show_final_summary()
	animation_player.play("PanelShowUp")
	print("Play test")
#endregion


func _on_click_to_show_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !fanfare_played:
			%Fanfare.play()
			fanfare_played = true


func _on_back_to_main_pressed() -> void:
	get_tree().paused = false
	GlobalData.set_score(points)
	GlobalData.games_played["airport"] += 1
	GameEvents.minigame_ended.emit()
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")
