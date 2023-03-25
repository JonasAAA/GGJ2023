extends Node

const save_file_name = "user://save.json"

var cur_level: String = "01"
export var use_new_visuals: bool = true
# Dictionary of {level_name(str): level_score(LevelScore)}
var best_level_scores: Dictionary

func _ready() -> void:
	randomize()
	print(use_new_visuals)
	load_game()
	
func load_game() -> void:
	print("bosdomf")
	var file = File.new()
	if not file.file_exists(save_file_name):
		return
	file.open(save_file_name, File.READ)
	var best_level_score_as_json: Dictionary = parse_json(file.get_line())
#	print("load file ", best_level_score_as_json)
	for level_name in best_level_score_as_json:
		var level_score_dict: Dictionary = best_level_score_as_json[level_name]
		best_level_scores[level_name] = LevelScore.new(level_score_dict["score"], level_score_dict["max_score"])

func save_game() -> void:
	var file = File.new()
	file.open(save_file_name, File.WRITE)
	var best_level_score_as_json = Dictionary()
	for level_name in best_level_scores:
		var level_score: LevelScore = best_level_scores[level_name]
		best_level_score_as_json[level_name] = level_score.to_dict()
#	print("save file ", best_level_score_as_json)
	file.store_line(to_json(best_level_score_as_json))
	file.close()
	
func stop_menu_music() -> void:
	$MenuMusicPlayer.stop()

func play_menu_music() -> void:
	$MenuMusicPlayer.play()
