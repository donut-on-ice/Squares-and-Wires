tool
class_name Fog extends TileMap

#### VARS ####
# enums
# consts
onready var Tiles := {
		EMPTY = TileMap.INVALID_CELL,
		FOG = tile_set.find_tile_by_name("Fog")
	}

# settings
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	
	if Engine.editor_hint:
		return
	
	set_visible(not Engine.editor_hint)
	add_to_group(Groups.SAVABLES)


#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func fill_with_fog(top_left:Vector2, bottom_down:Vector2) -> void:
	for y in range(top_left.y, bottom_down.y + 1):
		for x in range(top_left.x, bottom_down.x + 1):
			set_cell(x, y, Tiles.FOG)
	update_bitmask_region(top_left, bottom_down)


### updates ###
func unfog_arround_collision(collision:Dictionary, t_map):
	set_cellv((t_map.global_to_grid(collision.position)), -1)
	set_cellv((t_map.global_to_grid(collision.position - collision.normal)), -1)
	update_bitmask_area(t_map.global_to_grid(collision.position - collision.normal))

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###

### bools ###
### utils ###


#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	var cells_data := []
	cells_data.resize(get_used_rect().size.y)
	
	for j in range(get_used_rect().size.y):
	
		cells_data[j] = []
		cells_data[j].resize(get_used_rect().size.x)
	
		for i in range(get_used_rect().size.x):
			cells_data[j][i] = get_cellv(get_used_rect().position + Vector2(i, j))
	
	return {
		"position": get_used_rect().position,
		"cells_data": cells_data
	}


func from_data(data:Dictionary):
	
	if not data.has_all(["position", "cells_data"]):
		return
	
	clear()
	
	for j in range(data.cells_data.size()):
		for i in range(data.cells_data[j].size()):
			set_cellv(data.position + Vector2(i, j), data.cells_data[j][i])

	update_bitmask_region()

func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
