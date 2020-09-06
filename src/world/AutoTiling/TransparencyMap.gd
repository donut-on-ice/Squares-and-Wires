tool
class_name TransparencyMap extends TileMap

#### VARS ####
# enums
# consts
# settings
export(NodePath) var fog_map_path setget set_fog_map_path

# singletons
# nodes
onready var fog_map:Fog = get_node(fog_map_path)

# public
onready var Tiles := {
		EMPTY = TileMap.INVALID_CELL,
		TRANSPARENT = tile_set.find_tile_by_name("Transparent"),
		OPAQUE = tile_set.find_tile_by_name("Opaque")
	}

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_fog_map_path(path:String) -> void:
	
	fog_map_path = path
	
	if is_inside_tree():
		fog_map = get_node(fog_map_path)


func set_cell(x: int, y: int, tile: int, 
		flip_x: bool = false, flip_y: bool = false, transpose: bool = false, 
		autotile_coord: Vector2 = Vector2( 0, 0 )):
	
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	
	if Engine.editor_hint:
		fog_map.set_cell(x, y, fog_map.Tiles.FOG \
				if tile == Tiles.TRANSPARENT or tile == Tiles.OPAQUE \
				else fog_map.Tiles.EMPTY)


func apply_pattern(pattern:Array, top_left:Vector2) -> void:
	
	if Tiles == null:
		_ready()
	
	var x := int(top_left.x)
	var y := int(top_left.y)
	
	for row in pattern:
		
		for cell in row:
		
			var cell_id:int
		
			match cell:
				1: cell_id = Tiles.TRANSPARENT
				0: cell_id = Tiles.OPAQUE
				_: cell_id = Tiles.EMPTY
		
			set_cell(x, y, cell_id)
			x += 1
		
		y += 1
		x = int(top_left.x)

### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
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
