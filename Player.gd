extends Area2D

var is_moving: bool

func _ready() -> void:
	rotation = PI / 4

func initialize(start_pos: Vector2) -> void:
	position = start_pos
	is_moving = false
