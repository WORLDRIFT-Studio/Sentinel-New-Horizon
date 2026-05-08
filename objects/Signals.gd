extends Node
@warning_ignore_start("unused_signal")
signal IncrementScore(incr: int)
signal IncrementCombo()
signal ResetCombo()
signal CreateFallingKey(button_name: String, hit_time: float)
signal KeyListenerPress(button_name: String, array_num: int)

var music_player: AudioStreamPlayer2D = null

func get_song_time() -> float:
	if music_player == null or not music_player.playing:
		return 0.0
	return music_player.get_playback_position() \
		+ AudioServer.get_time_since_last_mix() \
		- AudioServer.get_output_latency()
