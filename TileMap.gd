extends TileMap

var matrix: Array
const grid_width = 4
const grid_height = 5

func _ready():
	matrix = []
#	for i in grid_width
	print(tile_set.tile_get_name(0))
	var tile_id = tile_set.find_tile_by_name("white tile.png 0")
	assert(tile_id != TileMap.INVALID_CELL)
	set_cell(5, 5, tile_id)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
