class_name SelectedNumber extends "res://src/puzzle/gui/Number.gd"

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

func _ready() -> void:
	add_to_group(Groups.IO_STATE_WATCHERS)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
# setters
# updates
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_state_change(state:int) -> void:
	set_number(state)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
