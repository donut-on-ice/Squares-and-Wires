extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends HBoxContainer
class_name OTHeader

#### VARS ####

# enums
# consts

# settings
# singletons
# nodes
onready var Nr:Number = $HiddenNr
onready var Labels:Array = [
		$Labels/O1,
		$Labels/O2,
		$Labels/O3,
		$Labels/O4]

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters

# updates
func update_number() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	Nr.set_hide_decimal_zero(StateHolder.input_nr != 4)


func update_visible_labels() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	Labels[4-1].set_visible(StateHolder.output_nr >= 4)
	Labels[3-1].set_visible(StateHolder.output_nr >= 3)
	Labels[2-1].set_visible(StateHolder.output_nr >= 2)
	Labels[1-1].set_visible(StateHolder.output_nr >= 1)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	update_number()


func on_output_nr_change() -> void:
	if StateHolder == null:
		return
	update_visible_labels()
	
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
