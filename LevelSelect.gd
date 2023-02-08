extends CanvasLayer

var level_button_and_info_template = preload("res://LevelButtonAndInfo.tscn")

func all_folders_in_dir(path: String) -> PoolStringArray:
	var dir: Directory = Directory.new()
	var dir_open_result = dir.open(path)
	assert(dir_open_result == OK)
	
	var folders: PoolStringArray = []
	dir.list_dir_begin()
	
	while true:
		var name = dir.get_next()
		if name == "":
			break
		elif dir.current_is_dir():
			if not name.begins_with("."):
				folders.append(name)
	
	dir.list_dir_end()
	return folders

func _ready():
	var level_names = all_folders_in_dir("res://music by level/")
	for level_name in level_names:
		var level_button_and_info = level_button_and_info_template.instance()
		level_button_and_info.initialize(level_name, str(GlobalState.best_level_scores.get(level_name, "--")))
		get_node("ScrollContainer/LevelSelectButtonContainer").add_child(level_button_and_info)

func _on_BackToMenuButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
