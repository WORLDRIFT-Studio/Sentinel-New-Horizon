extends Node2D

@onready var score: Label = %Score
@onready var combo: Label = %Combo
@onready var animation_player: AnimationPlayer = %AnimationPlayer

const in_edit_mode: bool = false
const LEVEL_DURATION: float = 30.0
const MIN_NOTE_INTERVAL: float = 0.5
const MAX_NOTE_INTERVAL: float = 1.2
const DOUBLE_NOTE_CHANCE: float = 0.35

var current_level_name = "RHYTHM_HELL"
var fk_fall_time: float = 1.65
var fk_output_arr = [[], [], [], []]
var fk_times_arr = [[], [], [], []]
var next_note_indices = [0, 0, 0, 0]
var button_names = ["button_Q", "button_W", "button_E", "button_R"]
var song_time: float = 0.0
var level_finished: bool = false

func _ready():
	GlobalData.games_played["airport"] += 1
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	
	Signals.music_player = $MusicPlayer
	_generate_notes()
	if in_edit_mode:
		Signals.KeyListenerPress.connect(KeyListenerPress)

func _generate_notes():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var t: float = 2.0
	while t < LEVEL_DURATION - fk_fall_time:
		var simultaneous = 2 if rng.randf() < DOUBLE_NOTE_CHANCE else 1
		var lanes = range(4)
		lanes.shuffle()
		for i in range(simultaneous):
			var stagger = rng.randf_range(0.0, 0.05) if i > 0 else 0.0
			fk_times_arr[lanes[i]].append(t + stagger)
		t += rng.randf_range(MIN_NOTE_INTERVAL, MAX_NOTE_INTERVAL)

func _process(delta):
	if in_edit_mode:
		return
	if level_finished:
		return

	song_time += delta
	Signals.manual_time = song_time
	$"../GameUI".UpdateTimer(LEVEL_DURATION - song_time)

	for i in range(4):
		while next_note_indices[i] < fk_times_arr[i].size():
			var hit_time = fk_times_arr[i][next_note_indices[i]]
			if hit_time > LEVEL_DURATION:
				break
			if song_time >= hit_time - fk_fall_time:
				Signals.CreateFallingKey.emit(button_names[i], hit_time)
				next_note_indices[i] += 1
			else:
				break

	if song_time >= LEVEL_DURATION:
		level_finished = true
		combo.text = "Najwyższe combo: %s" % str($"../GameUI".highest_combo)
		score.text = "Punkty: %s" % str($"../GameUI".score)
		animation_player.play("PanelShowUp")

func KeyListenerPress(_button_name: String, array_num: int):
	fk_output_arr[array_num].append(song_time - fk_fall_time)

func _on_music_player_finished():
	combo.text = "Najwyższe combo: %s" % str($"../GameUI".highest_combo)
	score.text = "Punkty: %s" % str($"../GameUI".score)
	animation_player.play("PanelShowUp")

func _on_continue_button_pressed() -> void:
	animation_player.play_backwards("PanelShowUp")
	await animation_player.animation_finished
	GameEvents.minigame_ended.emit()
	GlobalData.set_score($"../GameUI".score)
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")
