extends Panel

#region Zmienne

@onready var label: Label = %Label
@onready var slider: HSlider = %HSlider
@export_enum("Master", "Music", "SFX") var BUS:String

#endregion

var initialized: bool = false

func _ready() -> void:
	var key = "volume_" + BUS.to_lower()
	var saved_value = SaveLoad.contents_to_save[key]
	var data = {"value": saved_value, "bus": BUS}
	SettingsManager._set_setting("Audio", data)
	slider.value = saved_value
	label.text = BUS
	initialized = true

func _on_h_slider_value_changed(value: float) -> void:
	if not initialized:
		return
	var key = "volume_" + BUS.to_lower()
	var data = {"value": value, "bus": BUS}
	SettingsManager._set_setting("Audio", data)
	SaveLoad.contents_to_save[key] = value
	SaveLoad.save_content()
