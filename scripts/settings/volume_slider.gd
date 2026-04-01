extends Panel

#region Zmienne

@onready var label:Label = %Label
@export_enum("Master", "Music", "SFX") var BUS:String

#endregion

func _ready() -> void:
	label.text = BUS

func _on_h_slider_value_changed(value: float) -> void:
	var data = {"value": value, "bus":BUS}
	SettingsManager._set_setting("Audio", data)
