extends Node

@warning_ignore_start("unused_signal")

signal menu_opened(is_open:bool)

signal menu_closed(should_unpause:bool)

signal music_val_changed(bus:String, value: float)

signal show_alert_description(sender, title, description, difficulty, date, path)

signal delete_alert(node)

signal minigame_started

signal minigame_ended
