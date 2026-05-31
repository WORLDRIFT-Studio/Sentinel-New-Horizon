extends Sprite2D

@onready var falling_key = preload("res://scenes/minigames/raport_writer/falling_key.tscn")
@onready var score_text = preload("res://scenes/minigames/raport_writer/score_press_text.tscn")

var left_tex = preload("res://art/left.png")
var down_tex = preload("res://art/down.png")

@export var key_name: String = ""

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
	print("key_name is: ", key_name)
	print("left_tex is: ", left_tex)
	print("down_tex is: ", down_tex)
	match key_name:
		"left":
			texture = left_tex
		"right":
			texture = left_tex
			flip_h = true
		"down":
			texture = down_tex
		"up":
			texture = down_tex
			flip_v = true
	Signals.CreateFallingKey.connect(CreateFallingKey)

func _process(_delta):
	if Input.is_action_just_pressed(key_name):
		Signals.KeyListenerPress.emit(key_name)

	while falling_key_queue.size() > 0 and not is_instance_valid(falling_key_queue.front()):
		falling_key_queue.pop_front()

	if falling_key_queue.size() > 0:
		var front_key = falling_key_queue.front()
		var song_time = Signals.get_song_time()

		# Miss: note has passed the ok window
		if song_time - front_key.target_hit_time > ok_threshold:
			falling_key_queue.pop_front()
			front_key.queue_free()
			_spawn_score_text("MISS")
			Signals.ResetCombo.emit()

		# Input hit
		elif Input.is_action_just_pressed(key_name):
			var key_to_pop = falling_key_queue.pop_front()
			var time_diff = abs(song_time - key_to_pop.target_hit_time)

			print("song_time=", song_time, " target=", key_to_pop.target_hit_time, " diff=", time_diff)

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
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)

		var tex: Texture2D
		var fh := false
		var fv := false

		match key_name:
			"button_Q":
				tex = left_tex
			"button_W":
				tex = down_tex
				fv = true
			"button_E":
				tex = down_tex
			"button_R":
				tex = left_tex
				fh = true

		fk_inst.Setup(global_position.x, tex, fh, fv, hit_time)
		falling_key_queue.push_back(fk_inst)
