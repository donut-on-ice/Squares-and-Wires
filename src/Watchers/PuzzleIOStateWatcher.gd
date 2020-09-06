class_name PuzzleIOStateWatcher extends Node

#### VARS ####

# enums
# consts
# settings
# singletons

# nodes
var StateHolder:PuzzleIOStateHolder setget set_state_holder
var Parent:Node
var this_node = self

# public
# private
var notify_parent:bool = false setget set_notify_parent

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	add_to_group(Groups.IO_STATE_WATCHERS)
	get_tree().call_group(Groups.IO_STATE_HOLDERS,
			Groups.IOStateHolderFuncs.ON_NODE_IS_READY,
			self)


func _enter_tree() -> void:
	Parent = get_parent()


#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_state_holder(sh:PuzzleIOStateHolder) -> void:
	StateHolder = sh
	update_state_holder()


func set_notify_parent(b:bool) -> void:
	notify_parent = b
	if notify_parent:
		update_state_holder()


# updates
func update_state_holder() -> void:
	if !is_inside_tree():
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.IOStateWatcherFuncs.ON_IO_STATE_HOLDER_CHANGE):
			Parent.call(Groups.IOStateWatcherFuncs.ON_IO_STATE_HOLDER_CHANGE)
	
	self.call(Groups.IOStateWatcherFuncs.ON_INPUT_NR_CHANGE)
	self.call(Groups.IOStateWatcherFuncs.ON_INPUT_STATE_CHANGE)

	self.call(Groups.IOStateWatcherFuncs.ON_OUTPUT_NR_CHANGE)
	self.call(Groups.IOStateWatcherFuncs.ON_OUTPUT_STATES_CHANGE)
	self.call(Groups.IOStateWatcherFuncs.ON_REQUIRED_OUTPUT_STATES_CHANGE)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_io_state_holder_change(sh:PuzzleIOStateHolder) -> void:
	set_state_holder(sh)


func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.IOStateWatcherFuncs.ON_INPUT_NR_CHANGE):
			Parent.call(Groups.IOStateWatcherFuncs.ON_INPUT_NR_CHANGE)


func on_input_state_change() -> void:
	if StateHolder == null:
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.IOStateWatcherFuncs.ON_INPUT_STATE_CHANGE):
			Parent.call(Groups.IOStateWatcherFuncs.ON_INPUT_STATE_CHANGE)
	

func on_output_nr_change() -> void:
	if StateHolder == null:
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.IOStateWatcherFuncs.ON_OUTPUT_NR_CHANGE):
			Parent.call(Groups.IOStateWatcherFuncs.ON_OUTPUT_NR_CHANGE)


func on_output_states_change() -> void:
	if StateHolder == null:
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.IOStateWatcherFuncs.ON_OUTPUT_STATES_CHANGE):
			Parent.call(Groups.IOStateWatcherFuncs.ON_OUTPUT_STATES_CHANGE)
	
	
func on_required_output_states_change() -> void:
	if StateHolder == null:
		return
		
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.IOStateWatcherFuncs.ON_REQUIRED_OUTPUT_STATES_CHANGE):
			Parent.call(Groups.IOStateWatcherFuncs.ON_REQUIRED_OUTPUT_STATES_CHANGE)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
