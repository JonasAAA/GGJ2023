extends CanvasLayer

func _on_StartButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://LevelSelect.tscn")

func _on_RulesButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Rules.tscn")

func _on_CreditsButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Credits.tscn")

func _on_ExitButton_pressed() -> void:
	GlobalState.save_game()
	get_tree().quit()
