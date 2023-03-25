extends Panel

func initialize(level_name: String, score_text: String) -> void:
	$LevelSelectButton.text = level_name
	$Score.text = score_text

func _on_CustomButton_pressed() -> void:
	GlobalState.cur_level = $LevelSelectButton.text
# warning-ignore:return_value_discarded
	var scene_name: String
	if GlobalState.use_new_visuals:
		scene_name = "res://NewPresentation/Level.tscn"
	else:
		scene_name = "res://Level.tscn"
	print("bla ", GlobalState.use_new_visuals)
	get_tree().change_scene(scene_name)
