class_name PuzzleIOStateHolder extends Node

#### VARS ####

# enums
enum Values {
	INNACTIVE = 0, 
	FALSE = 1, 
	TRUE = 2, 
	ERROR = 3}
	
# consts
const MASK_FFFF = 0xFFFFFFFF

const MASK_1010 = 0xAAAAAAAA
const MASK_0101 = 0x55555555

# settings
# singletons
# nodes

# public

# there are at most 4 inputs. each of the first 4 bits from input_state are reserved to each input state
var input_state:int = 0 setget set_input_state
var input_nr:int = 4 setget set_input_nr

# req-state 0 -> 2^16-1 (short) -> fiecre 2 biti inseamna Values {INNACTIVE = 0, FALSE = 1, TRUE = 2, ERROR = 3}
var required_output_states:Array = [0, 0, 0, 0] setget set_required_output_states

# req-state 0 -> 2^16-1 (short) -> fiecre 2 biti inseamna Values {INNACTIVE = 0, FALSE = 1, TRUE = 2, ERROR = 3}
var output_states:Array = [0, 0 ,0 ,0] setget set_output_states
var output_nr:int = 4 setget set_output_nr

var is_active:bool = false setget set_active

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _input(event: InputEvent):
	
	if !(event is InputEventKey):
		return

	if Input.is_action_just_pressed("toggle_bit_1") and input_nr >= 1:
		set_input_state(input_state ^ (1 << 0))
	if Input.is_action_just_pressed("toggle_bit_2") and input_nr >= 2:
		set_input_state(input_state ^ (1 << 1))
	if Input.is_action_just_pressed("toggle_bit_3") and input_nr >= 3:
		set_input_state(input_state ^ (1 << 2))
	if Input.is_action_just_pressed("toggle_bit_4") and input_nr >= 4:
		set_input_state(input_state ^ (1 << 3))

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_active(a:bool):
	
	is_active = a
	
	if is_active: 
		get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME,
				Groups.IO_STATE_HOLDERS,
				Groups.IOStateHolderFuncs.ON_IO_STATE_HOLDER_CHANGE)
		add_to_group(Groups.IO_STATE_HOLDERS)
		get_tree().call_group(Groups.IO_STATE_WATCHERS,
				Groups.IOStateWatcherFuncs.ON_IO_STATE_HOLDER_CHANGE,
				self)
	else:
		 on_io_state_holder_change()


func set_input_state(i:int):
	input_state = i
	update_input_state_watchers()


func set_input_nr(i:int):
	input_nr = i
	update_input_nr_watchers()


func set_required_output_states(a:Array):
	required_output_states = a
	update_required_output_states_watchers()


func set_output_states(a:Array):
	output_states = a
	update_output_states_watchers()


func set_output_nr(i:int):
	output_nr = i
	update_output_nr_watchers()


# updates
func update_all_watchers():
	pass


func update_input_state_watchers():
	
	if !is_inside_tree():
		return
	
	get_tree().call_group(Groups.IO_STATE_WATCHERS,
			Groups.IOStateWatcherFuncs.ON_INPUT_STATE_CHANGE)


func update_input_nr_watchers():
	
	if !is_inside_tree():
		return
	
	get_tree().call_group(Groups.IO_STATE_WATCHERS,
			Groups.IOStateWatcherFuncs.ON_INPUT_NR_CHANGE)
	set_input_state(Utils.min_int(input_state, (1 << input_nr) - 1))


func update_required_output_states_watchers():
	
	if !is_inside_tree():
		return
	
	get_tree().call_group(Groups.IO_STATE_WATCHERS,
			Groups.IOStateWatcherFuncs.ON_REQUIRED_OUTPUT_STATES_CHANGE)


func update_output_states_watchers():
	
	if !is_inside_tree():
		return
	
	get_tree().call_group(Groups.IO_STATE_WATCHERS,
			Groups.IOStateWatcherFuncs.ON_OUTPUT_STATES_CHANGE)


func update_output_nr_watchers():
	
	if !is_inside_tree():
		return
	
	get_tree().call_group(Groups.IO_STATE_WATCHERS,
			Groups.IOStateWatcherFuncs.ON_OUTPUT_NR_CHANGE)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils
### getters

### bools
func are_outputs_matcing(nr_outs:int) -> Array:
	
	var matching := []
	
	for i in range(nr_outs):
		
		var req_out:int = required_output_states[i] & MASK_FFFF
		var out:int = output_states[i] & MASK_FFFF
		
		matching.append(req_out == out)
	
	return matching

#--# NON STATE CHANGING METHODS #--#


#### DATA METHODS ####

func to_data() -> Dictionary:

	return {
			"input_state":				input_state,
			"input_nr":					input_nr,
			"required_output_states":	required_output_states,
			"output_states":			output_states,
			"output_nr":				output_nr,
			"is_active":				is_active
		}


func from_data(data:Dictionary):
	
	if data.has("input_state"): input_state = data.input_state
	if data.has("input_nr"): input_nr = data.input_nr
	if data.has("required_output_states"): required_output_states = data.required_output_states
	if data.has("output_states"): output_states = data.output_states
	if data.has("output_nr"): output_nr = data.output_nr
	if data.has("is_active"): is_active = data.is_active


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_io_state_holder_change():
	remove_from_group(Groups.IO_STATE_HOLDERS)


func on_node_is_ready(n:Node):
	if n.has_method(Groups.IOStateWatcherFuncs.ON_IO_STATE_HOLDER_CHANGE):
		n.call(Groups.IOStateWatcherFuncs.ON_IO_STATE_HOLDER_CHANGE, self)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
