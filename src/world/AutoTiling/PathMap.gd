tool
class_name PathMap extends TileMap

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
onready var Tiles := {
		EMPTY = -1,
		WALKABLE = tile_set.find_tile_by_name("Walkable"),
		UNWALKABLE = tile_set.find_tile_by_name("Unwalkable") 
	}

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	pass

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func apply_pattern(pattern:Array, top_left:Vector2) -> void:
	
	if Tiles == null:
		_ready()
	
	var x := int(top_left.x)
	var y := int(top_left.y)
	
	for row in pattern:
		
		for cell in row:
		
			var cell_id := -1
			
			match cell:
				1: cell_id = Tiles.UNWALKABLE
				0: cell_id = Tiles.WALKABLE
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
