extends Node

var A_musical_phrases: Array
var B_musical_phrases: Array
var musical_phrase_durations: PoolRealArray

export var start_level = 1
# comment
export var first_phrase_duration: PoolRealArray = [2.4, 3.5]
export var other_phrase_durations: PoolRealArray = [2.4, 3.0]
const max_num_musical_phrases = 100

var playerMapPosHistory: PoolVector2Array
var can_player_move_back: bool

func _ready() -> void:
	randomize()
	start_level(start_level)

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
	A_musical_phrases = load_musical_phrases(level_num, 'A')
	B_musical_phrases = load_musical_phrases(level_num, 'B')
	assert(len(A_musical_phrases) == len(B_musical_phrases))
	musical_phrase_durations = [first_phrase_duration[level_num - 1]]
	for i in range(1, len(A_musical_phrases) + 1):
		musical_phrase_durations.append(other_phrase_durations[level_num - 1])
	
	$TileMap.initialize(len(A_musical_phrases))
	playerMapPosHistory = []
	$Player.initialize()
	queue_player_move($TileMap.get_player_start_pos())

func queue_player_move(new_pos: Vector2) -> void:
	var new_abs_pos = $TileMap.map_to_abs_pos(new_pos)
	if $Player.has_queued_pos:
		$Player.queue_next_pos(new_abs_pos)
		return
	if len(playerMapPosHistory) == 0:
		playerMapPosHistory.append(new_pos)
		$Player.position = new_abs_pos
		can_player_move_back = false
		return
	if new_pos == playerMapPosHistory[-1]:
		return
	$Player.queue_next_pos(new_abs_pos)
	$PlayerJumpTimer.wait_time = $MusicalPhraseTimer.time_left
	$PlayerJumpTimer.start()

func set_player_abs_pos(new_abs_pos: Vector2) -> void:
	var old_map_pos = $TileMap.abs_pos_to_map($Player.position)
	$Player.position = new_abs_pos
	var new_map_pos = $TileMap.abs_pos_to_map($Player.position)
	
	if not $TileMap.is_inside(new_map_pos):
		play_player_song()
		# TODO: victory!
	
	if old_map_pos != new_map_pos:
		if $TileMap.get_journey_length(new_map_pos) < $TileMap.get_journey_length(old_map_pos):
			playerMapPosHistory.remove(len(playerMapPosHistory) - 1)
			assert(playerMapPosHistory[-1] == new_map_pos)
			can_player_move_back = false
		else:
			playerMapPosHistory.append(new_map_pos)
			can_player_move_back = true
		var journey_length = $TileMap.get_journey_length(new_map_pos)
		if journey_length > 0:
			var audio_player = AudioStreamPlayer.new()
			if $TileMap.is_music_A(new_map_pos):
				audio_player.stream = A_musical_phrases[journey_length - 1]
			else:
				audio_player.stream = B_musical_phrases[journey_length - 1]
			audio_player.play()
			add_child(audio_player)
			$MusicalPhraseTimer.start(musical_phrase_durations[journey_length - 1])

func play_player_song() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		queue_player_move($TileMap.map_pos_to_left(playerMapPosHistory[-1]))
	if Input.is_action_just_pressed("move_right"):
		queue_player_move($TileMap.map_pos_to_right(playerMapPosHistory[-1]))
	if Input.is_action_just_pressed("move_back"):
		if can_player_move_back:
			queue_player_move(playerMapPosHistory[-2])
	$Camera2D.position = $Player.position

func _on_PlayerJumpTimer_timeout():
	set_player_abs_pos($Player.next_position)
	$Player.clear_queued_pos()
