extends Sprite

class_name RootSprite

static func get_vine_height() -> float:
	return 512.0 * 7 / 8

static func get_vine_width() -> float:
	return 512.0 * 1 / 2

func _get_start_rel_pos() -> Vector2:
	return Vector2.ZERO

func initialize(start_pos: Vector2, new_scale: Vector2) -> void:
	scale = new_scale
	position = start_pos - _get_start_rel_pos()
	
func get_end_pos() -> Vector2:
	return position - _get_start_rel_pos()
