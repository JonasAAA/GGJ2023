extends Node

enum DIRECTION {LEFT, RIGHT, DOWN, NONE}

var RootToLeftSprite = preload("res://RootSpriteScenes/ToLeft.tscn")
var RootToRightSprite = preload("res://RootSpriteScenes/ToRight.tscn")
var RootStartSprite = preload("res://RootSpriteScenes/Start.tscn")
var Stone = preload("res://Stone.tscn")
onready var MusicalPhraseTimer: Timer = $MusicalPhraseTimer
onready var Camera: Camera2D = $Camera
onready var LevelCompleteScreen = $LevelCompleteScreen
onready var MusicParticles: Particles2D = $MusicParticles

class History:
	var direction_history: PoolIntArray
	var sprite_history: Array
	var is_music_A_history: PoolByteArray
	
	func _init(start_direction: int, start_sprite: RootSprite, start_is_music_A: bool) -> void:
		direction_history = []
		sprite_history = []
		is_music_A_history = []
		append(start_direction, start_sprite, start_is_music_A)
	
	func append(direction: int, sprite: RootSprite, is_music_A: bool) -> void:
		direction_history.append(direction)
		sprite_history.append(sprite)
		is_music_A_history.append(is_music_A)
		
		var finalizeInd: int = max(len(sprite_history) - 2, 0)
		get_sprite(finalizeInd).finalize()
	
	func finalize_all_sprites() -> void:
		for sprite in sprite_history:
			sprite.finalize()
	
	func pop_back() -> void:
		direction_history.remove(len(direction_history) - 1)
		sprite_history.remove(len(sprite_history) - 1)
		is_music_A_history.remove(len(is_music_A_history) - 1)
	
	func get_last_dir() -> int:
		return direction_history[-1]
	
	func get_pos(index: int) -> Vector2:
		return get_sprite(index).get_end_pos()
	
	func get_last_pos() -> Vector2:
		return get_last_sprite().get_end_pos()
	
	func get_sprite(index: int) -> RootSprite:
		return sprite_history[index]
	
	func get_last_sprite() -> RootSprite:
		return sprite_history[-1]
	
	func get_last_is_music_A() -> bool:
		return is_music_A_history[-1] as bool
	
	func get_is_music_A(index: int) -> bool:
		return is_music_A_history[index] as bool
	
	func length() -> int:
		return len(direction_history)


export var first_phrase_duration: Dictionary = {"Test": 2.4, "01": 2.4, "02": 3.5}
export var other_phrase_durations: Dictionary = {"Test": 2.4, "01": 2.4, "02": 3.0}
export var level_complete_sound_length: float = 2.5
export var vine_height: float = 100
export var stone_to_vine_width_ratio = .5
const max_num_musical_phrases = 100

var level_complete_sound: AudioStream = preload("res://music level up/Music_levelup.wav")
var root_sprite_scale: Vector2
var vine_width: float
var level_name: String
var A_musical_phrases: Array
var B_musical_phrases: Array
var musical_phrase_durations: PoolRealArray
var is_complete: bool
var history: History
var is_left_music_A: PoolByteArray
var can_player_move_back: bool
var queued_move_dir: int
var queued_sprite: RootSprite


func _ready() -> void:
	var result = Wwise.load_bank_id(AK.BANKS.MAIN)
	print("is main loading successful? ", result)
	result = Wwise.register_listener(self)
	print("is registering listener successful? ", result)
	result = Wwise.register_game_obj(self, "Level")
	print("is wwise game object registering successful? ", result)
	start_level(GlobalState.cur_level)


func load_musical_phrases(music_name: String) -> Array:
	var musical_phrases = [null]
	for i in max_num_musical_phrases:
		var file_name = "res://music by level/" + level_name + "/" + music_name + "/" + str(i + 1).pad_zeros(2) + ".wav"
		var musical_phrase = load(file_name)
		if musical_phrase == null:
			break
		musical_phrases.append(musical_phrase)
	return musical_phrases


func start_level(new_level_name: String) -> void:
	var root_scale = vine_height / RootSprite.get_vine_height()
	root_sprite_scale = Vector2(root_scale, root_scale)
	vine_width = RootSprite.get_vine_width() * root_scale
	MusicParticles.hide()
	level_name = new_level_name
	GlobalState.stop_menu_music()
	is_complete = false
	LevelCompleteScreen.hide()
	A_musical_phrases = load_musical_phrases('A')
	B_musical_phrases = load_musical_phrases('B')
	assert(len(A_musical_phrases) == len(B_musical_phrases))
	musical_phrase_durations = [0, first_phrase_duration[level_name]]
	is_left_music_A = [randi() % 2]
	for _i in len(A_musical_phrases) - 1:
		musical_phrase_durations.append(other_phrase_durations[level_name])
		is_left_music_A.append(randi() % 2)
	var start_sprite: RootSprite = RootStartSprite.instance()
	start_sprite.initialize(RootSprite.SIZE.FULL, 0, get_start_pos(), root_sprite_scale)
	history = History.new(DIRECTION.NONE, start_sprite, is_left_music_A[0])
	add_child(start_sprite)
	Camera.position = history.get_last_pos()
	can_player_move_back = false
	queued_move_dir = DIRECTION.NONE
	queued_sprite = null
	place_stones()


func get_start_pos() -> Vector2:
	return Vector2(0, vine_height * (len(A_musical_phrases) - .5))


func place_stones() -> void:
	for i in range(-30, 30):
		for j in range(0, 20):
			if (i + j) % 2 != 0:
				continue
			var stone: Stone = Stone.instance()
			var position = Vector2(i * vine_width, j * vine_height)
			var width = stone_to_vine_width_ratio * vine_width
			stone.initialize(position, width)
			add_child(stone)


func remove_queued_sprite() -> void:
	if queued_sprite != null:
		remove_child(queued_sprite)
		queued_sprite = null


func queue_move(direction: int) -> void:
	assert(direction == DIRECTION.LEFT || direction == DIRECTION.RIGHT || direction == DIRECTION.DOWN)
	remove_queued_sprite()
	queued_move_dir = direction
	history.get_last_sprite().set_size(RootSprite.SIZE.FULL)
	var new_sprite: RootSprite = null
	if direction == DIRECTION.LEFT:
		new_sprite = RootToLeftSprite.instance()
	if direction == DIRECTION.RIGHT:
		new_sprite = RootToRightSprite.instance()
	if direction == DIRECTION.DOWN:
		history.get_last_sprite().set_size(RootSprite.SIZE.MEDIUM)
	queued_sprite = new_sprite
	if new_sprite != null:
		new_sprite.initialize(RootSprite.SIZE.SMALL, history.length(), history.get_last_pos(), root_sprite_scale)
		add_child(queued_sprite)


func move_to_next_pos(direction: int) -> void:
	remove_queued_sprite()
	if direction == DIRECTION.DOWN:
		remove_child(history.get_last_sprite())
		history.pop_back()
		can_player_move_back = false
		Camera.position = history.get_last_pos()
	else:
		assert(direction == DIRECTION.LEFT || direction == DIRECTION.RIGHT)
		var new_sprite: RootSprite
		if direction == DIRECTION.LEFT:
			new_sprite = RootToLeftSprite.instance()
		else:
			new_sprite = RootToRightSprite.instance()
		new_sprite.initialize(RootSprite.SIZE.FULL, history.length(), history.get_last_pos(), root_sprite_scale)
		add_child(new_sprite)
		if history.length() >= len(is_left_music_A):
			history.finalize_all_sprites()
			new_sprite.finalize()
			level_complete()
			return
		var is_music_A: bool
		if direction == DIRECTION.LEFT:
			is_music_A = is_left_music_A[history.length()]
		else:
			is_music_A = not is_left_music_A[history.length()]
		history.append(direction, new_sprite, is_music_A)
		can_player_move_back = true
	Camera.position = history.get_last_pos()
	play_phrase_from_history(history.length() -1)


func level_complete() -> void:
	remove_queued_sprite()
	is_complete = true
	var audio_player = MyAudioPlayer.new("Sound Effects")
	audio_player.stream = level_complete_sound
	add_child(audio_player)
	audio_player.play()
	yield(get_tree().create_timer(level_complete_sound_length), "timeout")
	var cur_score: LevelScore = LevelScore.new(0, len(A_musical_phrases) - 2)
	for i in range(2, history.length()):
		if history.get_is_music_A(i) == history.get_is_music_A(i - 1):
			cur_score.score += 1
	var prev_best_score: LevelScore = GlobalState.best_level_scores.get(level_name, cur_score)
	if prev_best_score.score <= cur_score.score:
		GlobalState.best_level_scores[level_name] = cur_score
	var best_score: LevelScore = GlobalState.best_level_scores[level_name]
	for i in range(1, history.length()):
		Camera.position = history.get_pos(i)
		var duration = play_phrase_from_history(i)
		yield(get_tree().create_timer(duration), "timeout")
	audio_player.play()
	LevelCompleteScreen.show("Level complete!\nScore {cur_score}\nBest Score {best_score}".format({"cur_score": cur_score, "best_score": best_score}))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		var playing_id = Wwise.post_event_id(AK.EVENTS.LEVEL_UP_EVENT, self)
		print("Triggering Wwise event LEVEL_UP_EVENT")
	if is_complete:
		return
	if Input.is_action_just_pressed("move_left"):
		queue_move(DIRECTION.LEFT)
	if Input.is_action_just_pressed("move_right"):
		queue_move(DIRECTION.RIGHT)
	if can_player_move_back && Input.is_action_just_pressed("move_down"):
		queue_move(DIRECTION.DOWN)
	
	if MusicalPhraseTimer.time_left == 0 && queued_move_dir != DIRECTION.NONE:
		move_to_next_pos(queued_move_dir)
		queued_move_dir = DIRECTION.NONE


# Returns duration of the phrase
func play_phrase_from_history(index: int) -> float:
	assert(index >= 0)
	if index == 0:
		return 0.0
	MusicParticles.position = history.get_pos(index)
	MusicParticles.show()
	var audio_player = MyAudioPlayer.new("Level Music")
	if history.get_is_music_A(index):
		audio_player.stream = A_musical_phrases[index]
	else:
		audio_player.stream = B_musical_phrases[index]
	audio_player.play()
	add_child(audio_player)
	var duration = musical_phrase_durations[index]
	MusicalPhraseTimer.start(duration)
	return duration


func _on_MusicalPhraseTimer_timeout() -> void:
	MusicParticles.hide()
	pass
