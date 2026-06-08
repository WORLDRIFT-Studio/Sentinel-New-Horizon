extends Control

@onready var tutor_txt: Label = %tutor_txt 
@onready var animation_panel: AnimationPlayer = %PanelAnimation

var score: int = 0
var combo_count: int = 0
var highest_combo: int = 0

func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	Signals.IncrementCombo.connect(IncrementCombo)
	Signals.ResetCombo.connect(ResetCombo)
	ResetCombo()

func IncrementScore(incr: int):
	score += incr
	%ScoreLabel.text = " " + str(score) + " pts"

func IncrementCombo():
	combo_count += 1
	%ComboLabel.text = " " + str(combo_count) + "x combo"

func ResetCombo():
	if combo_count > highest_combo:
		highest_combo = combo_count
	combo_count = 0
	%ComboLabel.text = ""

func UpdateTimer(time_left: float):
	%TimerLabel.text = str(ceili(time_left)) + "s"
