extends RootSprite

var small_texture: Texture = preload("res://Textures/small-root-to-right.png")
var medium_texture: Texture = preload("res://Textures/medium-root-to-right.png")
var full_texture: Texture = preload("res://Textures/root-to-right-new.png")

func _get_small_texture() -> Texture:
	return small_texture

func _get_medium_texture() -> Texture:
	return medium_texture

func _get_full_texture() -> Texture:
	return full_texture

func _get_start_rel_pos() -> Vector2:
	return Vector2(-texture.get_width() * scale.x * 0.25, texture.get_height() * scale.y * 7 / 16)
