extends TileMap

enum TILE_STATE {LOCKED, AVAILABLE, UNSEEN}

class Tile:
	var tile_state: int
	var texture_name: String
	var is_music_A: bool
	
	func _init(start_tile_state: int, tex_name: String, is_A: bool) -> void:
		tile_state = start_tile_state
		texture_name = tex_name
		is_music_A = is_A

var matrix: Array
var unseen_tile_id: int
var start_tile_id: int
var max_journey_length: int
var grid_width: int
var grid_height: int
var player_start_pos: Vector2
var tile_name_to_id: Dictionary

func set_tile(position: Vector2, tile_state: int, texture_name: String, is_A: bool) -> void:
	matrix[position.x][position.y] = Tile.new(tile_state, texture_name, is_A)
	set_cellv(position, get_tile_id(texture_name))

func get_tile_id(texture_name: String) -> int:
	var tile_id = tile_name_to_id.get(texture_name)
	if tile_id != null:
		return tile_id
	for i in 100:
		tile_id = tile_set.find_tile_by_name(texture_name + " " + str(i))
		if tile_id != TileMap.INVALID_CELL:
			tile_name_to_id[texture_name] = tile_id
			return tile_id
	assert(false)
	return TileMap.INVALID_CELL

func initialize(max_journey: int, empty_texture_name: String, start_texture_name: String) -> void:
	max_journey_length = max_journey
	
	grid_width = max_journey_length + 1
	grid_height = max_journey_length + 1
	player_start_pos = Vector2(0, grid_height - 1)
	
	matrix = []
	for i in grid_width:
		matrix.append([])
		for j in grid_height:
			matrix[i].append(null)
			var tile_pos = Vector2(i, j)
			if get_journey_length(tile_pos) <= max_journey_length:
				var prev_same_level_tile_pos = tile_pos - Vector2(1, 1)
				var is_music_A: bool
				if is_inside(prev_same_level_tile_pos):
					assert(get_journey_length(tile_pos) == get_journey_length(prev_same_level_tile_pos))
					is_music_A = not is_music_A(prev_same_level_tile_pos)
				else:
					is_music_A = randi() % 2 == 0
				set_tile(tile_pos, TILE_STATE.UNSEEN, empty_texture_name, is_music_A)
	set_tile(player_start_pos, TILE_STATE.AVAILABLE, start_texture_name, true)

func set_tile_texture(map_pos: Vector2, texture_name: String) -> void:
	if not is_inside(map_pos):
		set_cellv(map_pos, get_tile_id(texture_name))
		return
	var cur_tile: Tile = matrix[map_pos.x][map_pos.y]
	set_tile(map_pos, cur_tile.tile_state, texture_name, cur_tile.is_music_A)

func is_music_A(map_pos: Vector2) -> bool:
	return matrix[map_pos.x][map_pos.y].is_music_A 

func get_player_start_pos() -> Vector2:
	return player_start_pos
	
func is_inside(map_pos: Vector2) -> bool:
	if get_journey_length(map_pos) > max_journey_length:
		return false
	if map_pos.x < 0:
		return false
	if map_pos.y >= grid_height:
		return false
	return true

func map_to_abs_pos(map_pos: Vector2) -> Vector2:
	return to_global(map_to_world(map_pos) + cell_size / 2)

func abs_pos_to_map(abs_pos: Vector2) -> Vector2:
	return world_to_map(abs_pos - cell_size / 2)

func map_pos_to_up(map_pos: Vector2) -> Vector2:
	return map_pos + Vector2(0, -1)

func map_pos_to_left(map_pos: Vector2) -> Vector2:
	return map_pos + Vector2(-1, 0)

func map_pos_to_down(map_pos: Vector2) -> Vector2:
	return map_pos + Vector2(0, 1)

func map_pos_to_right(map_pos: Vector2) -> Vector2:
	return map_pos + Vector2(1, 0)

func get_journey_length(player_map_pos: Vector2) -> int:
	return (abs(player_map_pos.x - player_start_pos.x) + abs(player_map_pos.y - player_start_pos.y)) as int
