extends Panel

#region Zmienne

@onready var label: Label = %Label
@onready var slider: HSlider = %HSlider
@export_enum("Master", "Music", "SFX") var BUS:String

#endregion

func _ready() -> void:
	var key = "volume_" + BUS.to_lower()
	var saved_value = SaveLoad.contents_to_save[key]
	slider.value = saved_value
	label.text = BUS

func _on_h_slider_value_changed(value: float) -> void:
	var key = "volume_" + BUS.to_lower()
	var data = {"value": value, "bus": BUS}
	SettingsManager._set_setting("Audio", data)
	SaveLoad.contents_to_save[key] = value
	SaveLoad._save()
