tool
class_name Editor extends TileMap

#### VARS ####
# enums
# consts
# settings
export(NodePath) var terrain_node_path
export(NodePath) var objects_node_path
export(NodePath) var fog_node_path

# singletons
# nodes
onready var terrain_node:Terrain = get_node(terrain_node_path)
onready var objects_node:ObjectManager = get_node(objects_node_path)
onready var fog_node:Fog = get_node(fog_node_path)

# public
onready var Tiles := EditorTileIDs.new(tile_set)

# private
var old_pos:Vector2 = Vector2(-100000000, -100000000)
var old_tile:int = -1

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	pass

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_cell(x:int, y:int, tile:int, 
		_flip_x:bool = false, _flip_y:bool = false, _transpose:bool = false, 
		autotile_coord:Vector2 = Vector2(0, 0)) -> void:
	
	if Tiles == null:
		_ready()
	
	var pos := (get_local_mouse_position()/cell_size).floor()
	
	if pos.x == x and pos.y == y \
			and (old_pos.x != pos.x or old_pos.y != pos.y or old_tile != tile) \
			and (Input.is_mouse_button_pressed(BUTTON_LEFT) or Input.is_mouse_button_pressed(BUTTON_RIGHT)):
	
		old_pos.x = pos.x
		old_pos.y = pos.y
		old_tile = tile
		
		var d := {}
		d.x = x
		d.y = y
		
		d.pos = Vector2(x, y)
		
		d.autotile_coord = autotile_coord
		
		match tile:
			Tiles.DOOR_EW:
				d.tile = objects_node.Tiles.DOOR_EW
				objects_node.apply_object(d)
			
			Tiles.DOOR_NS:
				d.tile = objects_node.Tiles.DOOR_NS
				objects_node.apply_object(d)
			
			Tiles.CONTROL_BOARD:
				d.tile = objects_node.Tiles.CONTROL_BOARD
				objects_node.apply_object(d)
			
			Tiles.UPGRADE_SCREEN:
				d.tile = objects_node.Tiles.UPGRADE_SCREEN
				objects_node.apply_object(d)
		

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

class EditorTileIDs:
	const EMPTY := TileMap.INVALID_CELL
	var DOOR_EW:int
	var DOOR_NS:int
	var CONTROL_BOARD:int
	var UPGRADE_SCREEN:int
	
	func _init(tile_set:TileSet) -> void:
		DOOR_EW = tile_set.find_tile_by_name("Door EW")
		DOOR_NS = tile_set.find_tile_by_name("Door NS")
		CONTROL_BOARD = tile_set.find_tile_by_name("Control Board")
		UPGRADE_SCREEN = tile_set.find_tile_by_name("Upgrade Screen")

#--# CLASSES #--#
