extends TileMap

enum TILE_STATE {LOCKED, AVAILABLE, UNSEEN}

class Tile:
	var tile_state: int
	var tile_id: int
	
	func _init(start_tile_state: int, start_tile_id: int) -> void:
		tile_state = start_tile_state
		tile_id = start_tile_id
	

var matrix: Array
const grid_width = 4
const grid_height = 5

func generate_grid() -> void:
	var tile_id = tile_set.find_tile_by_name("basic tile set.png 4")
	assert(tile_id != TileMap.INVALID_CELL)
	
	matrix = []
	for i in grid_width:
		matrix.append([])
		for j in grid_height:
			matrix[i].append(Tile.new(TILE_STATE.UNSEEN, tile_id))
			set_cell(i, j, matrix[i][j].tile_id)

func get_player_start_pos() -> Vector2:
	return to_global(map_to_world(Vector2(0, grid_height - 1)) + cell_size / 2)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		pass
	if Input.is_action_just_pressed("move_right"):
		pass
	if Input.is_action_just_pressed("move_back"):
		pass
