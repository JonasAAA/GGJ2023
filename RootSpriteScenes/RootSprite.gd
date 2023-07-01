extends Sprite

class_name RootSprite

static func get_temp_color() -> Color:
	# Use this instead of Color(...) since it's only possible
	# to copy this reprensentation to the Godot GUI, not the other one
	return Color("179525")

static func get_final_color() -> Color:
	return Color("33290b")

static func get_vine_height() -> float:
	return 512.0 * 7 / 8

static func get_vine_width() -> float:
	return 512.0 * 1 / 2

func _get_small_texture() -> Texture:
	assert(false, "must be overriden")
	return null

func _get_medium_texture() -> Texture:
	assert(false, "must be overriden")
	return null

func _get_full_texture() -> Texture:
	assert(false, "must be overriden")
	return null

func _get_start_rel_pos() -> Vector2:
	assert(false, "must be overriden")
	return Vector2.ZERO

enum SIZE { SMALL, MEDIUM, FULL }

func initialize(size: int, index: int, start_pos: Vector2, new_scale: Vector2) -> void:
	scale = new_scale
	position = start_pos - _get_start_rel_pos()
	set_size(size)
	modulate = get_temp_color()
	z_index = 4095 - index

func set_size(size: int) -> void:
	assert(size == SIZE.SMALL || size == SIZE.MEDIUM || size == SIZE.FULL)
	if size == SIZE.SMALL:
		texture = _get_small_texture()
	if size == SIZE.MEDIUM:
		texture = _get_medium_texture()
	if size == SIZE.FULL:
		texture = _get_full_texture()

func finalize() -> void:
	modulate = get_final_color()

func get_end_pos() -> Vector2:
	return position - _get_start_rel_pos()
