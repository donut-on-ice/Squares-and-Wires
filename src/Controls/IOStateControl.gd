extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends Node

#### VARS ####

# enums
# consts
# settings

export(int, 0, 65.535) var required_output_1:int = 0 setget set_required_output_1
export(int, 0, 65.535) var required_output_2:int = 0 setget set_required_output_2
export(int, 0, 65.535) var required_output_3:int = 0 setget set_required_output_3
export(int, 0, 65.535) var required_output_4:int = 0 setget set_required_output_4

# singletons
# nodes
# public

# private
var _required_output_states:Array = [0, 0, 0, 0]

# signals

#--# VARS #--#



#### MAIN METHODS ####
func _ready() -> void:
	update_required_output()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_required_output_1(i:int) -> void:
	if required_output_1 == i:
		return
	required_output_1 = i
	_required_output_states[0] = required_output_1
	update_required_output()


func set_required_output_2(i:int) -> void:
	if required_output_2 == i:
		return
	required_output_2 = i
	_required_output_states[1] = required_output_2
	update_required_output()


func set_required_output_3(i:int) -> void:
	if required_output_3 == i:
		return
	required_output_3 = i
	_required_output_states[2] = required_output_3
	update_required_output()


func set_required_output_4(i:int) -> void:
	if required_output_4 == i:
		return
	required_output_4 = i
	_required_output_states[3] = required_output_4
	update_required_output()


# updates
func update_required_output() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	StateHolder.set_required_output_states(_required_output_states)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
### bools ###

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_io_state_holder_change(sh:PuzzleIOStateHolder) -> void:
	set_state_holder(sh)
	update_required_output()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
