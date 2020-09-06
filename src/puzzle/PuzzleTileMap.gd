class_name PuzzleTileMap extends TileMap

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	var size := get_used_rect().size
	
	var cell_ids := []
	var cell_auto_tile_coords := []
	
	cell_ids.resize(size.y)
	cell_auto_tile_coords.resize(size.y)
	
	for j in range(size.y):
	
		cell_ids[j] = []
		cell_auto_tile_coords[j] = []
		
		cell_ids[j].resize(size.x)
		cell_auto_tile_coords[j].resize(size.x)
	
		for i in range(size.x):
			
			var pos := get_used_rect().position + Vector2(i, j)
			
			cell_ids[j][i] = get_cell(pos.x, pos.y)
			cell_auto_tile_coords[j][i] = get_cell_autotile_coord(pos.x, pos.y)
			
	
	return {
		"position": Vector2(get_used_rect().position),
		"cell_ids": cell_ids,
		"cell_auto_tile_coords": cell_auto_tile_coords
	}


func from_data(data:Dictionary):
	
	if not data.has_all(["position", "cell_ids", "cell_auto_tile_coords"]):
		return
	
	for j in range(data.cell_ids.size()):
		
		for i in range(data.cell_ids[j].size()):
			
			var pos:Vector2 = data.position + Vector2(i, j)
			
			set_cell(pos.x, pos.y, data.cell_ids[j][i],
					false, false, false,
					data.cell_auto_tile_coords[j][i])


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
