extends TileMap

enum TILE_STATE {LOCKED, AVAILABLE, UNSEEN}

class Tile:
	var tile_state: int
	var tile_id: int
	var is_music_A: bool
	
	func _init(start_tile_state: int, start_tile_id: int, is_A: bool) -> void:
		tile_state = start_tile_state
		tile_id = start_tile_id
		is_music_A = is_A

var matrix: Array
var unseen_tile_id: int
var start_tile_id: int
var max_journey_length: int
var grid_width: int
var grid_height: int
var player_start_pos: Vector2

func set_tile(position: Vector2, tile_state: int, tile_id: int, is_A: bool) -> void:
	matrix[position.x][position.y] = Tile.new(tile_state, tile_id, is_A)
	set_cellv(position, tile_id)

func initialize(max_journey: int) -> void:
	max_journey_length = max_journey
	unseen_tile_id = tile_set.find_tile_by_name("basic tile set.png 4")
	assert(unseen_tile_id != TileMap.INVALID_CELL)
	
	start_tile_id = tile_set.find_tile_by_name("basic tile set.png 3")
	assert(start_tile_id != TileMap.INVALID_CELL)
	
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
				set_tile(tile_pos, TILE_STATE.UNSEEN, unseen_tile_id, is_music_A)
	set_tile(player_start_pos, TILE_STATE.AVAILABLE, start_tile_id, true)

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

func map_pos_to_left(map_pos: Vector2) -> Vector2:
	return map_pos + Vector2(0, -1)

func map_pos_to_right(map_pos: Vector2) -> Vector2:
	return map_pos + Vector2(1, 0)

func abs_int(value: int) -> int:
	if value > 0:
		return value
	else:
		return -value

func get_journey_length(player_map_pos: Vector2) -> int:
	return abs_int(player_map_pos.x - player_start_pos.x) + abs_int(player_map_pos.y - player_start_pos.y)
