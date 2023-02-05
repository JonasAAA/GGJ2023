extends Area2D

var has_queued_pos: bool
var next_position: Vector2
var next_direction: int

func _ready() -> void:
	rotation = PI / 4

func initialize() -> void:
	has_queued_pos = false

func queue_next_pos(next_pos: Vector2, next_dir: int) -> void:
	next_position = next_pos
	next_direction = next_dir
	has_queued_pos = true

func clear_queued_pos() -> void:
	has_queued_pos = false
	
