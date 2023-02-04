extends Node

func _ready() -> void:
	start_level()

func start_level() -> void:
	$TileMap.generate_grid()
	$Player.set_start_pos($TileMap.get_player_start_pos())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		pass
	if Input.is_action_just_pressed("move_right"):
		pass
	if Input.is_action_just_pressed("move_back"):
		pass


func _on_Player_body_entered(body: Node) -> void:
	pass
