extends Node

var cur_level: String = "01"

func _ready() -> void:
	randomize()
	
func stop_menu_music() -> void:
	$MenuMusicPlayer.stop()

func play_menu_music() -> void:
	$MenuMusicPlayer.play()
