extends Node

@warning_ignore("unused_signal")
signal menu_opened(is_open:bool)

@warning_ignore("unused_signal")
signal menu_closed()

@warning_ignore("unused_signal")
signal music_val_changed(bus:String, value: float)

@warning_ignore("unused_signal")
signal checkbox_marked(options:String, value:bool)
