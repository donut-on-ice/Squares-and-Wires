class_name OutputPanelLabel extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends HBoxContainer

#### VARS ####

# enums
enum States {FALSE, TRUE}

# consts

# settings
export(int, 1, 4) var index:int = 1 setget set_index

# singletons

# nodes
onready var LED:OutputLight = $Center/LED
onready var LabelIndex:TextureRect = $Center/Index

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	update_index()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_index(i:int) -> void:
	index = i
	update_index()


# updates
func update_index() -> void:
	if !is_inside_tree():
		return
	LabelIndex.set_texture(PUtils.path_digits[index%PUtils.path_digits.size()])
	update_false_true()
	update_req_ls()


func update_req_ls() -> void:
	if StateHolder == null:
		return
	#ros[1:s, 2:s, 3:s, 4:s] s = short 16 biti
	var required_logic_state = StateHolder.required_output_states[index-1]
	required_logic_state = required_logic_state >> (StateHolder.input_state * 2)
	required_logic_state = required_logic_state % 4
	LED.set_required_logic_state(required_logic_state == PuzzleIOStateHolder.Values.TRUE)


func update_false_true() -> void:
	if StateHolder == null:
		return
	# states[1:[sf, st], 2:[sf, st], 3:[sf,st], 4:[sf, st]]
	# sf = short false
	# st = short true
	var false_true:int = StateHolder.output_states[index-1]
	false_true = false_true >> (StateHolder.input_state * 2)
	false_true = false_true & 0x03
	LED.set_false_true(false_true)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_state_change() -> void:
	if StateHolder == null:
		return
	update_req_ls()
	update_false_true()


func on_required_output_states_change() -> void:
	if StateHolder == null:
		return
	update_req_ls()


func on_output_states_change() -> void:
	if StateHolder == null:
		return
	update_false_true()


func on_output_nr_change() -> void:
	if StateHolder == null:
		return
	this_node.set_visible(index <= StateHolder.output_nr) 

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
