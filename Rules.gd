extends CanvasLayer

func _on_BackToMenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainMenu.tscn")
