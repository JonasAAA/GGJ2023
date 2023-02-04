extends TileMap

enum TILE_STATE {LOCKED, AVAILABLE, UNSEEN}

class Tile:
	var tile_state: int
	var tile_id: int
	
	func _init(start_tile_state: int, start_tile_id: int) -> void:
		tile_state = start_tile_state
		tile_id = start_tile_id

var matrix: Array
var unseen_tile_id: int
var start_tile_id: int
const grid_width = 4
const grid_height = 5
const player_start_pos = Vector2(0, grid_height - 1)
var last_player_abs_pos: Vector2
var can_move_back: bool

func set_tile(position: Vector2, tile_state: int, tile_id: int) -> void:
	matrix[position.x][position.y] = Tile.new(tile_state, tile_id)
	set_cellv(position, tile_id)

func initialize() -> void:
	unseen_tile_id = tile_set.find_tile_by_name("basic tile set.png 4")
	assert(unseen_tile_id != TileMap.INVALID_CELL)
	
	start_tile_id = tile_set.find_tile_by_name("basic tile set.png 3")
	assert(start_tile_id != TileMap.INVALID_CELL)
	
	matrix = []
	for i in grid_width:
		matrix.append([])
		for j in grid_height:
			matrix[i].append(null)
			set_tile(Vector2(i, j), TILE_STATE.UNSEEN, unseen_tile_id)
	set_tile(player_start_pos, TILE_STATE.AVAILABLE, start_tile_id)
	
	can_move_back = false
	last_player_abs_pos = tile_to_abs_pos(player_start_pos)

func get_player_start_pos() -> Vector2:
	return last_player_abs_pos

func tile_to_abs_pos(tile_pos: Vector2) -> Vector2:
	return to_global(map_to_world(tile_pos) + cell_size / 2)

func abs_pos_to_tile(abs_pos: Vector2) -> Vector2:
	return world_to_map(abs_pos - cell_size / 2)

func try_move_player_left(player_abs_pos: Vector2) -> Vector2:
	can_move_back = true
	last_player_abs_pos = player_abs_pos
	return player_abs_pos + Vector2(0, -cell_size.y)

func try_move_player_right(player_abs_pos: Vector2) -> Vector2:
	can_move_back = true
	last_player_abs_pos = player_abs_pos
	return player_abs_pos + Vector2(cell_size.x, 0)

func try_move_player_back(player_abs_pos: Vector2) -> Vector2:
	if not can_move_back:
		return player_abs_pos
	can_move_back = false
	return last_player_abs_pos

func abs_int(value: int) -> int:
	if value > 0:
		return value
	else:
		return -value

func get_journey_length(player_abs_pos: Vector2) -> int:
	var player_tile_pos = abs_pos_to_tile(player_abs_pos)
	return abs_int(player_tile_pos.x - player_start_pos.x) + abs_int(player_tile_pos.y - player_start_pos.y)
