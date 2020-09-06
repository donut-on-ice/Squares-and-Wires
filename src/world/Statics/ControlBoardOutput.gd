tool
class_name ControlBoardOutput extends StaticBody2D


#### VARS ####
# enums

# consts
const INPUT_MASKS := [0x1111, 0x2222, 0x4444, 0x8888]

# settings
export(bool) var is_auto_solved:bool = false

export(int, 1, 4) var input_bits:int = 1 setget set_input_bits
# required_input_as_int -> 2^16-1 (short) -> fiecre 1 biti inseamna "req true" sau "req fals" FORMAT SMALL
export(int, FLAGS, "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F") var required_output_small setget set_required_output_small

# singletons
# nodes
# public
# private
var input_provided:bool = false setget set_input_provided, is_input_provided
var control_board_to_input:Dictionary = {}

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	set_input_bits(input_bits)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_required_output_small(small:int):
	
	var change:int = required_output_small ^ small
	required_output_small = small
	
	if change == 0:
		return
	
	var SHIFT = 1 << input_bits
	var MASK = ~(~0 << SHIFT)
	
	while not bool(change & MASK):
		change = change >> SHIFT
		required_output_small = required_output_small >> SHIFT
	
	required_output_small &= MASK
	var i := 1 << input_bits
	while i < 16:
		required_output_small |= required_output_small << i
		i = i << 1


func set_input_bits(bits:int):
	
	bits = clamp(bits, 1, 4)
	
	var MASK = ~(~0 << (1 << input_bits))
	input_bits = bits
	
	required_output_small &= MASK
	var i := 1 << input_bits
	while i < 16:
		required_output_small |= required_output_small << i
		i = i << 1


# TODO to be overriden
func set_input_provided(ip:bool) -> void:
	
	input_provided = ip


### updates ###
func update_input_provided() -> void:
	
	var it_is := false
	
	for v in control_board_to_input.values():
		it_is = v or it_is
	
	set_input_provided(it_is)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func is_input_provided() -> bool:
	return input_provided or is_auto_solved

### bools ###
### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	return {
		"input_provided": input_provided,
		"control_board_to_input": control_board_to_input
	}


func from_data(data:Dictionary):
	
	if data.has("input_provided"): input_provided = data.input_provided
	if data.has("control_board_to_input"): control_board_to_input =	data.control_board_to_input

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#


