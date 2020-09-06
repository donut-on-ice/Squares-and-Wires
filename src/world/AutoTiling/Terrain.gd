tool
class_name Terrain extends TileMap

#### VARS ####
# enums
# consts
onready var Tiles := {
		EMPTY =			TileMap.INVALID_CELL,
		WALL =			tile_set.find_tile_by_name("Wall"),
		METAL_FLOOR =	tile_set.find_tile_by_name("Metal Floor"),
		PIT =			tile_set.find_tile_by_name("Pit")
	}

# settings
# singletons
# nodes
onready var transparency_node:TransparencyMap = $TransparencyMap
onready var path_node:PathMap = $Navigation2D/PathMap

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	pass

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_cell(x:int, y:int, tile:int, 
		flip_x:bool = false, flip_y:bool = false, transpose:bool = false, 
		autotile_coord:Vector2 = Vector2(0, 0)) -> void:
	
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	
	match tile:
	
		Tiles.WALL:
			update_bitmask_area(Vector2(x, y))
	
		Tiles.METAL_FLOOR:
			pass
		
		Tiles.EMPTY, _:
			pass
	
	path_node.apply_pattern(get_path_pattern(x, y, tile), 2 * Vector2(x, y))
	transparency_node.apply_pattern(get_transparency_pattern(x, y, tile), 2 * Vector2(x, y))
	


func apply_tile(t:Dictionary) -> void:
	
	if Tiles == null:
		_ready()
	
	set_cell(t.x ,t.y, t.tile, 
			false, false, false,
			t.autotile_coord)


# warning-ignore:unused_argument
func apply_object(o:Dictionary) -> void:
	# TODO static object influence visibility and pathfinding
	pass

### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###

func get_transparency_pattern(x:int, y:int, tile:int) -> Array:
	
	var pattern := get_raw_transparency_pattern(tile)
	var other_pattern := []
	
	other_pattern = get_raw_transparency_pattern(get_cell(x + 1, y))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(1, 0), other_pattern)
	
	other_pattern = get_raw_transparency_pattern(get_cell(x - 1, y))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(-1, 0), other_pattern)
	
	other_pattern = get_raw_transparency_pattern(get_cell(x, y + 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(0, 1), other_pattern)
	
	other_pattern = get_raw_transparency_pattern(get_cell(x, y - 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(0, -1), other_pattern)
	
	other_pattern =  get_raw_transparency_pattern(get_cell(x + 1, y + 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(1, 1), other_pattern)

	other_pattern =  get_raw_transparency_pattern(get_cell(x - 1, y - 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(-1, -1), other_pattern)
	
	other_pattern =  get_raw_transparency_pattern(get_cell(x + 1, y - 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(+1, -1), other_pattern)
	
	other_pattern =  get_raw_transparency_pattern(get_cell(x - 1, y + 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(-1, +1), other_pattern)
	
	return pattern


func get_raw_transparency_pattern(tile:int) -> Array:
	
	if Tiles == null:
		_ready()
	
	var pattern := [[-1, -1, -1],
					[-1, -1, -1],
					[-1, -1, -1]]
	
	var T := 1
	var O := 0
	
	match tile:
		
		Tiles.WALL:
			pattern = [ [O, O, O],
						[O, O, O],
						[O, O, O]]
			
			
		Tiles.METAL_FLOOR, Tiles.PIT:
			pattern = [ [T, T, T],
						[T, T, T],
						[T, T, T]]
					
		Tiles.EMPTY, _:
			pattern = [ [-1, -1, -1],
						[-1, -1, -1],
						[-1, -1, -1]]
	
	return pattern


func get_path_pattern(x:int, y:int, tile:int) -> Array:
	
	var pattern := get_raw_path_pattern(tile)
	var other_pattern := []
	
	other_pattern = get_raw_path_pattern(get_cell(x + 1, y))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(1, 0), other_pattern)
	
	other_pattern = get_raw_path_pattern(get_cell(x - 1, y))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(-1, 0), other_pattern)
	
	other_pattern = get_raw_path_pattern(get_cell(x, y + 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(0, 1), other_pattern)
	
	other_pattern = get_raw_path_pattern(get_cell(x, y - 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(0, -1), other_pattern)
	
	other_pattern =  get_raw_path_pattern(get_cell(x + 1, y + 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(1, 1), other_pattern)

	other_pattern =  get_raw_path_pattern(get_cell(x - 1, y - 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(-1, -1), other_pattern)
	
	other_pattern =  get_raw_path_pattern(get_cell(x + 1, y - 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(+1, -1), other_pattern)
	
	other_pattern =  get_raw_path_pattern(get_cell(x - 1, y + 1))
	pattern = overlap_with_neighbour_patterns(pattern, Vector2(-1, +1), other_pattern)
	
	return pattern

func get_raw_path_pattern(tile:int) -> Array:
	
	if Tiles == null:
		_ready()
	
	var pattern:Array
	
	var W := 0
	var U := 1
	
	match tile:
	
		Tiles.WALL, Tiles.PIT:
			pattern = [ [U, U, U],
						[U, U, U],
						[U, U, U]]
		
		Tiles.METAL_FLOOR:
			pattern = [ [W, W, W],
						[W, W, W],
						[W, W, W]]
		
		Tiles.EMPTY, _:
			pattern = [ [-1, -1, -1],
						[-1, -1, -1],
						[-1, -1, -1]]
	
	return pattern

func overlap_with_neighbour_patterns(pattern:Array, n_relative_pos:Vector2, n_pattern:Array) -> Array:
	
	match n_relative_pos:
		Vector2(0, 1):
			pattern[2][0] = max(pattern[2][0], n_pattern[0][0])
			pattern[2][1] = max(pattern[2][1], n_pattern[0][1])
			pattern[2][2] = max(pattern[2][2], n_pattern[0][2])
	
		Vector2(0, -1):
			pattern[0][0] = max(pattern[0][0], n_pattern[2][0])
			pattern[0][1] = max(pattern[0][1], n_pattern[2][1])
			pattern[0][2] = max(pattern[0][2], n_pattern[2][2])
		
		Vector2(1, 0):
			pattern[0][2] = max(pattern[0][2], n_pattern[0][0])
			pattern[1][2] = max(pattern[1][2], n_pattern[1][0])
			pattern[2][2] = max(pattern[2][2], n_pattern[2][0])
			
		Vector2(-1, 0):
			pattern[0][0] = max(pattern[0][0], n_pattern[0][2])
			pattern[1][0] = max(pattern[1][0], n_pattern[1][2])
			pattern[2][0] = max(pattern[2][0], n_pattern[2][2])
		
		Vector2(1, 1):
			pattern[2][2] = max(pattern[2][2], n_pattern[0][0])
		
		Vector2(-1, -1):
			pattern[0][0] = max(pattern[0][0], n_pattern[2][2])
		
		Vector2(-1 , 1):
			pattern[2][0] = max(pattern[2][0], n_pattern[0][2])
		
		Vector2(1, -1):
			pattern[0][2] = max(pattern[0][2], n_pattern[2][0])
			
	
	return pattern

### bools ###
### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
