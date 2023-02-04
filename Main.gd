extends Node

var A_musical_phrases: Array
var B_musical_phrases: Array

export var max_num_musical_phrases = 100

var playerMapPosHistory: PoolVector2Array

func _ready() -> void:
	start_level(1)

func load_musical_phrases(level_num: int, name: String) -> Array:
	var musical_phrases = []
	for i in max_num_musical_phrases:
		var file_name = "res://Music/level" + str(level_num).pad_zeros(2) + "/" + name + "/" + str(i + 1).pad_zeros(2) + ".wav"
		var musical_phrase = load(file_name)
		if musical_phrase == null:
			break
		musical_phrases.append(musical_phrase)
	return musical_phrases

func start_level(level_num: int) -> void:
	$TileMap.initialize()
#	playerMapPosHistory
	$Player.initialize($TileMap.get_player_start_pos())
	A_musical_phrases = load_musical_phrases(level_num, 'A')
	B_musical_phrases = load_musical_phrases(level_num, 'B')
	assert(len(A_musical_phrases) == len(B_musical_phrases))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		try_move_player($TileMap.try_move_player_left($Player.position), 2)
	if Input.is_action_just_pressed("move_right"):
		try_move_player($TileMap.try_move_player_right($Player.position), 2)
	if Input.is_action_just_pressed("move_back"):
		try_move_player($TileMap.try_move_player_back($Player.position), 2)
	$Camera2D.position = $Player.position

func try_move_player(destin: Vector2, duration: float) -> void:
	if destin == $Player.position:
		return
	if $Player.is_moving:
		return
	$Player.position = destin

func _on_Player_body_entered(body: Node) -> void:
	if body is TileMap:
		var journey_length = $TileMap.get_journey_length($Player.position)
		print(journey_length)
		if journey_length > 0:
			var audio_player = AudioStreamPlayer.new()
			audio_player.stream = A_musical_phrases[journey_length - 1]
			audio_player.play()
			add_child(audio_player)
	


func _on_Player_body_exited(body: Node) -> void:
	pass
