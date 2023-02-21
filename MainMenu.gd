extends CanvasLayer

func _on_StartButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://LevelSelect.tscn")

func _on_RulesButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Rules.tscn")

func _on_CreditsButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Credits.tscn")

func _on_CustomButton_pressed():
	GlobalState.save_game()
	get_tree().quit()
