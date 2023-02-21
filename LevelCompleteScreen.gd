extends CanvasLayer

func show(text: String) -> void:
	$Label.text = text
	$Label.show()
	$BackToMenuButton.show()

func hide() -> void:
	$Label.hide()
	$BackToMenuButton.hide()

func _on_BackToMenuButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://LevelSelect.tscn")
