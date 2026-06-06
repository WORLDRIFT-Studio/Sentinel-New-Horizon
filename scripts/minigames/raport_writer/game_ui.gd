extends Control

@onready var shadow1: Node = $shadow1
@onready var shadow2: Node = $shadow2
@onready var tutor_txt: Label = %tutor_txt 
@onready var animation_panel: AnimationPlayer = %PanelAnimation

var tutorial_step: int = 0
var is_tutorial: bool = false
var tutorial_done = false

var score: int = 0
var combo_count: int = 0
var highest_combo: int = 0

func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncrementCombo.connect(IncrementCombo)
	Signals.ResetCombo.connect(ResetCombo)
	ResetCombo()
	
	shadow1.visible = false
	shadow2.visible = false

	
	if _is_first_run():
		start_tutorial()

func _is_first_run() -> bool:
	return not GlobalData.has_completed_tutorial3()

var can_advance: bool = false

func set_tutor_text(new_text: String) -> void:
	can_advance = false  # Blokuj podczas animacji
	tutor_txt.text = new_text
	tutor_txt.visible_characters = 0
	
	var tween = create_tween()
	tween.tween_property(tutor_txt, "visible_characters", new_text.length(), 0.01 * new_text.length())
	tween.tween_callback(func(): can_advance = true)  # Odblokuj po animacji

func _input(event: InputEvent) -> void:
	if not is_tutorial or tutorial_done or not can_advance:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		can_advance = false  # Zapobiega podwójnemu kliknięciu
		_advance_tutorial()

func start_tutorial() -> void:
	is_tutorial = true
	tutorial_step = 0
	
	shadow1.visible = false
	shadow2.visible = false
	
	animation_panel.play("panel_anim")
	tutor_txt.visible = true
	set_tutor_text("Witaj w sekcji szkoleniowej pisania raportów. Aby rozpocząć szkolenie kliknij w pokazany tekst.")

func _advance_tutorial() -> void:
	tutorial_step += 1

func IncrementScore(incr: int):
	score += incr
	%ScoreLabel.text = " " + str(score) + " pts"

func IncrementCombo():
	combo_count += 1
	%ComboLabel.text = " " + str(combo_count) + "x combo"

func ResetCombo():
	if combo_count > highest_combo: highest_combo = combo_count
	combo_count = 0
	%ComboLabel.text = ""
