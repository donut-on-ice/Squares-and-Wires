extends Resource
class_name IOLight

#### VARS ####
# enums
# consts
const fixed_input:Array = [
		0x99999999,
		0xA5A5A5A5,
		0xAA55AA55,
		0xAAAA5555
	]
const OFF_TRUTH_TABLE:int = 0x00000000
const CYCLE_TRUTH_TABLE:int = 0xFFFFFFFF

# settings
# singletons
# nodes
# public
var parent #:Component
var position:Point
var is_on_wall:bool
var is_input:bool
var logic_state:int #PUtils.LogicState {OFF, FALSE, TRUE, UNDEFINED}
var simple_direction:int #PUtils.SimpleOrientation {W, E, S, N}

# every 2 bits are a logic state for diferent puzzle input values.
# EXAMPLE 
# 	for puzzle inputs:
#		I4 = false 
#		I3 = true
#		I2 = false
#		I1 = false
#	which is equivalent with STATE_INDEX 4
#	this io state will be (logic_table >> (4*2)) & 0x00000003
var is_truth_table_set:bool = false
var truth_table:int

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _init(
		par,
		p:Point = Point.new(), \
		ls:int = PUtils.LogicState.OFF, \
		sd:int = PUtils.SimpleOrientation.S, \
		is_wall:bool = false, \
		is_in:bool = false) -> void:
	parent = par
	position = Point.new(p.x, p.y)
	logic_state = ls
	simple_direction = sd
	is_on_wall = is_wall
	is_input = is_in

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func reset_truth_table() -> void:
	truth_table = OFF_TRUTH_TABLE
	is_truth_table_set = false


func set_fixed_input(index:int) -> void:
	if !is_emitter():
		return
	truth_table = fixed_input[index]


func set_cycle_truth_table() -> void:
	if !is_emitter():
		return 
	
	truth_table = CYCLE_TRUTH_TABLE


func lock_truth_table() -> void:
	is_truth_table_set = true


func set_current_logic_state(current:int) -> void:
	logic_state = (truth_table >> (current*2)) & 0x00000003

# updates
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
func get_light_tid() -> int:
	if is_on_wall:
		if is_input:
			return parent.Tiles.LIGHT_WALL_IN
		else:
			return parent.Tiles.LIGHT_WALL_OUT
	else:
		if is_input:
			return parent.Tiles.LIGHT_GATE_IN
		else:
			return parent.Tiles.LIGHT_GATE_OUT


func get_light_atls_pos() -> Vector2:
	return Vector2(simple_direction, logic_state)


### bools ###
func is_emitter() -> bool:
	return (is_on_wall and is_input) or (!is_on_wall and !is_input)


func is_sink() -> bool:
	return (is_on_wall and !is_input) or (!is_on_wall and is_input)  

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
