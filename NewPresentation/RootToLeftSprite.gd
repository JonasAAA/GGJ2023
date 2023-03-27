extends RootSprite

func _get_start_rel_pos() -> Vector2:
	return Vector2(texture.get_width() * scale.x * 0.25, texture.get_height() * scale.y * 7 / 16)
