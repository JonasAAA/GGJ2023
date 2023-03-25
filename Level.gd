extends Node

enum DIRECTION {UP, LEFT, DOWN, RIGHT, NONE}

class MoveData:
	var map_pos: Vector2
	# direction of move made to end up here
	var direction: int
	
	func _init(pos: Vector2, dir: int) -> void:
		map_pos = pos
		direction = dir

export var first_phrase_duration: Dictionary = {"Test": 2.4, "01": 2.4, "02": 3.5}
export var other_phrase_durations: Dictionary = {"Test": 2.4, "01": 2.4, "02": 3.0}
export var level_complete_sound_length: float = 2.5
const dir_to_str = {DIRECTION.UP: "top", DIRECTION.LEFT: "left", DIRECTION.DOWN: "bottom", DIRECTION.RIGHT: "right"}
const max_num_musical_phrases = 100

var level_complete_sound: AudioStream = preload("res://music level up/Music_levelup.wav")
var level_name
var A_musical_phrases: Array
var B_musical_phrases: Array
var musical_phrase_durations: PoolRealArray
var is_complete: bool
var moveDataHistory: Array
var can_player_move_down: bool
var can_player_move_left: bool

func load_musical_phrases(music_name: String) -> Array:
	var musical_phrases = []
	for i in max_num_musical_phrases:
		var file_name = "res://music by level/" + level_name + "/" + music_name + "/" + str(i + 1).pad_zeros(2) + ".wav"
		var musical_phrase = load(file_name)
		if musical_phrase == null:
			break
		musical_phrases.append(musical_phrase)
	return musical_phrases

func start_level(new_level_name: String) -> void:
	$MusicParticles.hide()
	level_name = new_level_name
	GlobalState.stop_menu_music()
	is_complete = false
	$LevelCompleteScreen.hide()
	A_musical_phrases = load_musical_phrases('A')
	B_musical_phrases = load_musical_phrases('B')
	assert(len(A_musical_phrases) == len(B_musical_phrases))
	musical_phrase_durations = [first_phrase_duration[level_name]]
	for _i in len(A_musical_phrases) - 1:
		musical_phrase_durations.append(other_phrase_durations[level_name])
	
	$TileMap.initialize(len(A_musical_phrases), empty_texture_name(), seed_texture_name())
	moveDataHistory = []
	$Player.initialize()
	queue_player_move($TileMap.get_player_start_pos(), DIRECTION.NONE)

func queue_player_move(new_map_pos: Vector2, direction: int) -> void:
	var new_abs_pos = $TileMap.map_to_abs_pos(new_map_pos)
	if $Player.has_queued_pos:
		$Player.queue_next_pos(new_abs_pos, direction)
		return
	if len(moveDataHistory) == 0:
		moveDataHistory.append(MoveData.new(new_map_pos, direction))
		$Player.position = new_abs_pos
		can_player_move_down = false
		can_player_move_left = false
		return
	if new_map_pos == moveDataHistory[-1].map_pos:
		return
	$Player.queue_next_pos(new_abs_pos, direction)
	if $MusicalPhraseTimer.time_left == 0:
		_on_PlayerJumpTimer_timeout()
	$PlayerJumpTimer.start($MusicalPhraseTimer.time_left)

func opposite_dir(dir: int) -> int:
	if dir == DIRECTION.DOWN:
		return DIRECTION.UP
	if dir == DIRECTION.UP:
		return DIRECTION.DOWN
	if dir == DIRECTION.LEFT:
		return DIRECTION.RIGHT
	if dir == DIRECTION.RIGHT:
		return DIRECTION.LEFT
	if dir == DIRECTION.NONE:
		return DIRECTION.NONE
	assert(false)
	return -1

func texture_name_from_dirs(from: int, to: int) -> String:
	if from == DIRECTION.NONE:
		return "tiles_branch_" + dir_to_str[to] + ".svg"
	return "tiles_vine_" + dir_to_str[opposite_dir(from)] + "_" + dir_to_str[to] + ".svg"

func texture_name_from_dir(dir: int) -> String:
	if dir == DIRECTION.NONE:
		return "tiles_seed.svg"
	return "tiles_branch_" + dir_to_str[opposite_dir(dir)] + ".svg"

func empty_texture_name() -> String:
	return "tiles_earth.svg"
	
func seed_texture_name() -> String:
	return "tiles_seed.svg"

func final_texture_name() -> String:
	return "tiles_blossom.svg"

func set_player_abs_pos(new_abs_pos: Vector2, direction: int) -> void:
	var old_map_pos = $TileMap.abs_pos_to_map($Player.position)
	$Player.position = new_abs_pos
	var new_map_pos = $TileMap.abs_pos_to_map($Player.position)

	if not $TileMap.is_inside(new_map_pos):
		$TileMap.set_tile_texture(old_map_pos, texture_name_from_dirs(moveDataHistory[-1].direction, DIRECTION.UP))
		$TileMap.set_tile_texture($TileMap.map_pos_to_up(old_map_pos), final_texture_name())
		level_complete()
		return

	if old_map_pos != new_map_pos:
		if $TileMap.get_journey_length(new_map_pos) < $TileMap.get_journey_length(old_map_pos):
			moveDataHistory.remove(len(moveDataHistory) - 1)
			$TileMap.set_tile_texture(new_map_pos, texture_name_from_dir(moveDataHistory[-1].direction))
			$TileMap.set_tile_texture(old_map_pos, empty_texture_name())
			assert(moveDataHistory[-1].map_pos == new_map_pos)
			can_player_move_down = false
			can_player_move_left = false
		else:
			$TileMap.set_tile_texture(new_map_pos, texture_name_from_dir(direction))
			$TileMap.set_tile_texture(old_map_pos, texture_name_from_dirs(moveDataHistory[-1].direction, direction))
			moveDataHistory.append(MoveData.new(new_map_pos, direction))
			if direction == DIRECTION.UP:
				can_player_move_down = true
				can_player_move_left = false
			if direction == DIRECTION.RIGHT:
				can_player_move_down = false
				can_player_move_left = true
		var journey_length = $TileMap.get_journey_length(new_map_pos)
		if journey_length > 0:
# warning-ignore:return_value_discarded
			play_phrase_from_map(new_map_pos)

func level_complete() -> void:
	is_complete = true
	var audio_player = MyAudioPlayer.new("Sound Effects")
	audio_player.stream = level_complete_sound
	add_child(audio_player)
	audio_player.play()
	yield(get_tree().create_timer(level_complete_sound_length), "timeout")
	var cur_score: LevelScore = LevelScore.new(0, len(A_musical_phrases) - 1)
	for i in range(2, len(moveDataHistory)):
		if $TileMap.is_music_A(moveDataHistory[i].map_pos) == $TileMap.is_music_A(moveDataHistory[i - 1].map_pos):
			cur_score.score += 1
	var prev_best_score: LevelScore = GlobalState.best_level_scores.get(level_name, cur_score)
	if prev_best_score.score <= cur_score.score:
		GlobalState.best_level_scores[level_name] = cur_score
	var best_score: LevelScore = GlobalState.best_level_scores[level_name]
	for move_data in moveDataHistory:
		var duration = play_phrase_from_map(move_data.map_pos)
		yield(get_tree().create_timer(duration), "timeout")
	audio_player.play()
	$LevelCompleteScreen.show("Level complete!\nScore {cur_score}\nBest Score {best_score}".format({"cur_score": cur_score, "best_score": best_score}))

func _process(_delta: float) -> void:
	if is_complete:
		return
	if Input.is_action_just_pressed("move_up"):
		queue_player_move($TileMap.map_pos_to_up(moveDataHistory[-1].map_pos), DIRECTION.UP)
	if Input.is_action_just_pressed("move_right"):
		queue_player_move($TileMap.map_pos_to_right(moveDataHistory[-1].map_pos), DIRECTION.RIGHT)
	if can_player_move_down && Input.is_action_just_pressed("move_down"):
		queue_player_move(moveDataHistory[-2].map_pos, DIRECTION.DOWN)
	if can_player_move_left && Input.is_action_just_pressed("move_left"):
		queue_player_move(moveDataHistory[-2].map_pos, DIRECTION.LEFT)
	$Camera2D.position = $Player.position

# Returns duration of the phrase
func play_phrase_from_map(map_pos: Vector2) -> float:
	var journey_length = $TileMap.get_journey_length(map_pos)
	if journey_length == 0:
		return 0.0
	$MusicParticles.position = $TileMap.map_to_abs_pos(map_pos)
	$MusicParticles.show()
	var audio_player = MyAudioPlayer.new("Level Music")
	if $TileMap.is_music_A(map_pos):
		audio_player.stream = A_musical_phrases[journey_length - 1]
	else:
		audio_player.stream = B_musical_phrases[journey_length - 1]
	audio_player.play()
	add_child(audio_player)
	var duration = musical_phrase_durations[journey_length - 1]
	$MusicalPhraseTimer.start(duration)
	return duration

func _on_PlayerJumpTimer_timeout() -> void:
	if is_complete:
		return
	set_player_abs_pos($Player.next_position, $Player.next_direction)
	$Player.clear_queued_pos()

func _on_Level_tree_entered() -> void:
	start_level(GlobalState.cur_level)

func _on_MusicalPhraseTimer_timeout() -> void:
	$MusicParticles.hide()
