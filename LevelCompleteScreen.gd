extends CanvasLayer

func show(text: String) -> void:
	$Label.text = text
	$Label.show()

func hide() -> void:
	$Label.hide()
