extends Sprite2D

@onready var falling_key = preload("res://scenes/minigames/raport_writer/falling_key.tscn")
@onready var score_text  = preload("res://scenes/minigames/raport_writer/score_press_text.tscn")

var note_tex   = preload("res://art/note.png")
var down_tex   = preload("res://art/down.png")
var sfx_stream = preload("res://art/keyboard.mp3")

@export var key_name: String = ""

var sfx_player: AudioStreamPlayer
var falling_key_queue = []

var perfect_threshold: float = 0.022
var great_threshold:   float = 0.045
var good_threshold:    float = 0.075
var ok_threshold:      float = 0.110

var perfect_press_score: float = 250
var great_press_score:   float = 100
var good_press_score:    float = 50
var ok_press_score:      float = 20

func _ready():
	sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = sfx_stream
	sfx_player.volume_db = -6.0
	add_child(sfx_player)
	if key_name != "":
		_apply_receptor_visuals(self)
	Signals.CreateFallingKey.connect(CreateFallingKey)

func _apply_receptor_visuals(target: Sprite2D):
	target.texture = note_tex
	target.flip_h = false
	target.flip_v = false
	target.rotation = 0.0
	target.offset = Vector2(0, 0)
	match key_name:
		"button_Q":
			target.rotation = PI / 2.0
		"button_W":
			target.flip_v = true
		"button_E":
			pass
		"button_R":
			target.rotation = -PI / 2.0

func _apply_falling_visuals(target: Sprite2D):
	target.texture = down_tex
	target.flip_h = false
	target.flip_v = false
	target.rotation = 0.0
	target.offset = Vector2(0, 0)
	match key_name:
		"button_Q":
			target.rotation = PI / 2.0
			target.offset = Vector2(0, -5.0)
		"button_W":
			target.flip_v = true
			target.offset = Vector2(5.0, 0)
		"button_E":
			target.offset = Vector2(5.0, 0)
		"button_R":
			target.rotation = -PI / 2.0
			target.offset = Vector2(0, -5.0)

func _process(_delta):
	if key_name == "":
		return

	if Input.is_action_just_pressed(key_name):
		Signals.KeyListenerPress.emit(key_name)
		if sfx_player and sfx_player.stream:
			sfx_player.play()

	while falling_key_queue.size() > 0 and not is_instance_valid(falling_key_queue.front()):
		falling_key_queue.pop_front()

	if falling_key_queue.size() > 0:
		var front_key = falling_key_queue.front()
		var song_time = Signals.get_song_time()

		if song_time - front_key.target_hit_time > ok_threshold:
			falling_key_queue.pop_front()
			front_key.queue_free()
			_spawn_score_text("MISS")
			Signals.ResetCombo.emit()
		elif Input.is_action_just_pressed(key_name):
			var key_to_pop = falling_key_queue.pop_front()
			var time_diff  = abs(song_time - key_to_pop.target_hit_time)
			$AnimationPlayer.stop()
			$AnimationPlayer.play("key_hit")
			var press_score_text: String = ""
			if time_diff < perfect_threshold:
				Signals.IncrementScore.emit(perfect_press_score)
				press_score_text = "PERFECT"
				Signals.IncrementCombo.emit()
			elif time_diff < great_threshold:
				Signals.IncrementScore.emit(great_press_score)
				press_score_text = "GREAT"
				Signals.IncrementCombo.emit()
			elif time_diff < good_threshold:
				Signals.IncrementScore.emit(good_press_score)
				press_score_text = "GOOD"
				Signals.IncrementCombo.emit()
			elif time_diff < ok_threshold:
				Signals.IncrementScore.emit(ok_press_score)
				press_score_text = "OK"
				Signals.IncrementCombo.emit()
			else:
				press_score_text = "MISS"
				Signals.ResetCombo.emit()
			key_to_pop.queue_free()
			_spawn_score_text(press_score_text)

func _spawn_score_text(label: String):
	var st_inst = score_text.instantiate()
	get_tree().get_root().call_deferred("add_child", st_inst)
	st_inst.SetTextInfo(label)
	st_inst.global_position = global_position + Vector2(0, -20)

func CreateFallingKey(button_name: String, hit_time: float):
	if button_name != key_name:
		return
	var fk_inst = falling_key.instantiate()
	_apply_falling_visuals(fk_inst)
	get_tree().get_root().add_child(fk_inst)
	fk_inst.Setup(global_position.x, fk_inst.texture, fk_inst.flip_h, fk_inst.flip_v, fk_inst.rotation, hit_time)
	falling_key_queue.push_back(fk_inst)
