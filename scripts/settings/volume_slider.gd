extends Panel

#region Zmienne

@onready var label:Label = %Label
@export var text:String
@export_enum("Master", "Music", "SFX") var BUS:String

#endregion

func _ready() -> void:
	label.text = text

func _on_h_slider_value_changed(value: float) -> void:
	var bus_id = AudioServer.get_bus_index(BUS)
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_id, db)
