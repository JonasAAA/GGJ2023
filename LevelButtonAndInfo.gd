extends Panel

func initialize(level_name: String, score_text: String) -> void:
	$LevelSelectButton.text = level_name
	$Score.text = score_text

func _on_CustomButton_pressed() -> void:
	GlobalState.cur_level = $LevelSelectButton.text
	get_tree().change_scene("res://Level.tscn")
