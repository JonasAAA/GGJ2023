extends Sprite

class_name RootSprite

func _get_start_rel_pos() -> Vector2:
	return Vector2.ZERO

func initialize(start_pos: Vector2, new_scale: Vector2) -> void:
	scale = new_scale
	position = start_pos - _get_start_rel_pos()
	
func get_end_pos() -> Vector2:
	return position - _get_start_rel_pos()
