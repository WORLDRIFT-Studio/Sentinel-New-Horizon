extends Panel


@onready var distance: Label = %Distance
@onready var score: Label = %Score
@onready var pr: Label = %PR
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	owner.connect("amublanse_hit", _on_amublanse_hit)

	
func _on_amublanse_hit(value: float) -> void:
	distance.text = "Przebyty dystans to: %.2f km" % (value / 1000)
	score.text = "Zdobyte punkty: %d" % value
	pr.text = "Zdobyte punkty reputacji: %d" % (value / 1000)
	animation_player.play("PanelShowUp")
	@warning_ignore("narrowing_conversion")
	GlobalData.set_score(value)

func _on_continue_button_pressed() -> void:
	print("powrot")
	get_tree().paused = false
	GameEvents.minigame_ended.emit()
	TransitionScene.fade_to_scene("res://scenes/main_game.tscn")
