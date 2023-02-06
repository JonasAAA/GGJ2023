extends CanvasLayer

func _on_StartButton_pressed():
	get_tree().change_scene("res://LevelSelect.tscn")

func _on_RulesButton_pressed():
	get_tree().change_scene("res://Rules.tscn")

func _on_CreditsButton_pressed():
	get_tree().change_scene("res://Credits.tscn")

func _on_CustomButton_pressed():
	get_tree().quit()
