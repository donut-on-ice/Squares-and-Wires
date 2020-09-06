extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends HBoxContainer
class_name ITHeader

#### VARS ####

# enums
# consts
# settings
# singletons

# nodes
onready var Nr:Number = $HiddenNr
onready var Labels:Array = [
		$Labels/I1,
		$Labels/I2,
		$Labels/I3,
		$Labels/I4]

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters

# updates
func update_visible_labels() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	
	Nr.set_hide_decimal_zero(StateHolder.input_nr != 4)
	Labels[4-1].set_visible(StateHolder.input_nr >= 4)
	Labels[3-1].set_visible(StateHolder.input_nr >= 3)
	Labels[2-1].set_visible(StateHolder.input_nr >= 2)
	Labels[1-1].set_visible(StateHolder.input_nr >= 1)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	update_visible_labels()
	
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
