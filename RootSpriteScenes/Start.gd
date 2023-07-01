extends RootSprite

var small_texture: Texture = preload("res://Textures/root-start.png")
var medium_texture: Texture = small_texture
var full_texture: Texture = small_texture

func _get_small_texture() -> Texture:
	return small_texture

func _get_medium_texture() -> Texture:
	return medium_texture

func _get_full_texture() -> Texture:
	return full_texture

func _get_start_rel_pos() -> Vector2:
	return Vector2.ZERO
