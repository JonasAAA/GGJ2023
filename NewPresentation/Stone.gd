extends Sprite

class_name Stone

func initialize(pos: Vector2, width: float) -> void:
	position = pos
	var scaleXY = width / texture.get_width()
	scale = Vector2(scaleXY, scaleXY)
