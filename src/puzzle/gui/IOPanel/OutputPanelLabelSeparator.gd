extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends TextureRect

#### VARS ####

# enums
# consts

# settings
export(int, 2, 4) var index:int = 2 setget set_index

# singletons
# nodes
# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_index(i:int) -> void:
	index = i

# updates

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_output_nr_change() -> void:
	if StateHolder == null:
		return
	this_node.set_visible(index <= StateHolder.output_nr) 

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
