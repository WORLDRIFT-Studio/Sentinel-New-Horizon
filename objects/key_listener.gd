extends Sprite2D
@onready var falling_key = preload("res://objects/falling_key.tscn")
@onready var score_text = preload("res://objects/score_press_text.tscn")
@export var key_name: String = ""
var falling_key_queue = []
var perfect_press_threshold: float = 30
var great_press_threshold: float = 50
var good_press_threshold: float = 60
var ok_press_threshold: float = 80
var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20

func _ready():
	$GlowOverlay.frame = frame + 4
	Signals.CreateFallingKey.connect(CreateFallingKey)

func _process(delta):
	if Input.is_action_just_pressed(key_name):
		Signals.KeyListenerPress.emit(key_name, frame)
	
	if falling_key_queue.size() > 0:
		
		# Remove any freed instances from the front
		while falling_key_queue.size() > 0 and not is_instance_valid(falling_key_queue.front()):
			falling_key_queue.pop_front()
		
		if falling_key_queue.size() > 0:
			# If that falling key has passed, remove it from the queue
			if falling_key_queue.front().has_passed:
				falling_key_queue.pop_front()
				
				var st_inst = score_text.instantiate()
				get_tree().get_root().call_deferred("add_child", st_inst)
				st_inst.SetTextInfo("MISS")
				st_inst.global_position = global_position + Vector2(0, -20)
				Signals.ResetCombo.emit()
			
			# If key is pressed, pop from the queue and calculate distance
			if Input.is_action_just_pressed(key_name):
				var key_to_pop = falling_key_queue.pop_front()
				
				var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
				
				$AnimationPlayer.stop()
				$AnimationPlayer.play("key_hit")
				
				var press_score_text: String = ""
				if distance_from_pass < perfect_press_threshold:
					Signals.IncrementScore.emit(perfect_press_score)
					press_score_text = "PERFECT"
					Signals.IncrementCombo.emit()
				elif distance_from_pass < great_press_threshold:
					Signals.IncrementScore.emit(great_press_score)
					press_score_text = "GREAT"
					Signals.IncrementCombo.emit()
				elif distance_from_pass < good_press_threshold:
					Signals.IncrementScore.emit(good_press_score)
					press_score_text = "GOOD"
					Signals.IncrementCombo.emit()
				elif distance_from_pass < ok_press_threshold:
					Signals.IncrementScore.emit(ok_press_score)
					press_score_text = "OK"
					Signals.IncrementCombo.emit()
				else:
					press_score_text = "MISS"
					Signals.ResetCombo.emit()
				
				key_to_pop.queue_free()
				
				var st_inst = score_text.instantiate()
				get_tree().get_root().call_deferred("add_child", st_inst)
				st_inst.SetTextInfo(press_score_text)
				st_inst.global_position = global_position + Vector2(0, -20)

func CreateFallingKey(button_name: String):
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.x, frame + 4)
		falling_key_queue.push_back(fk_inst)

func _on_random_spawn_timer_timeout():
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
