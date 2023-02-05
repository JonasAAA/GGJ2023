extends CanvasLayer

var level_select_button_template = preload("res://LevelSelectButton.tscn")

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
	for i in len(level_names):
		var level_select_button: Button = level_select_button_template.instance()
		level_select_button.text = level_names[i]
		level_select_button.rect_position = Vector2(1920 / 2, (i + 1) * 200) - level_select_button.rect_size / 2
		level_select_button.connect("pressed", self, "_on_LevelSelectButton_pressed", [level_names[i]])
		add_child(level_select_button)

func _on_LevelSelectButton_pressed(level_name: String) -> void:
	GlobalState.cur_level = level_name
	get_tree().change_scene("res://Level.tscn")
