class_name LockpadStateWatcher extends Node

#### VARS ####

# enums
# consts
# settings
# singletons
# nodes
var StateHolder:LockpadStateHolder setget set_state_holder
var Parent:Node
var this_node = self

# public
var notify_parent:bool = false setget set_notify_parent

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	add_to_group(Groups.LOCKPAD_STATE_WATCHERS)
	get_tree().call_group(Groups.LOCKPAD_STATE_HOLDERS,
			Groups.IOStateHolderFuncs.ON_NODE_IS_READY,
			self)


func _enter_tree() -> void:
	Parent = get_parent()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_state_holder(sh:LockpadStateHolder):
	StateHolder = sh
	update_state_holder()


func set_notify_parent(b:bool) -> void:
	notify_parent = b
	if notify_parent:
		update_state_holder()


### updates ###
func update_state_holder():
	if !is_inside_tree():
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.LockpadStateWatcherFuncs.ON_LOCKPAD_STATE_HOLDER_CHANGE):
			Parent.call(Groups.LockpadStateWatcherFuncs.ON_LOCKPAD_STATE_HOLDER_CHANGE)
	
	self.call(Groups.LockpadStateWatcherFuncs.ON_SOLUTION_CHANGE)
	self.call(Groups.LockpadStateWatcherFuncs.ON_REQUIRED_FORMULA_TYPE_CHANGE)


func on_solution_change():
	if StateHolder == null:
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.LockpadStateWatcherFuncs.ON_SOLUTION_CHANGE):
			Parent.call(Groups.LockpadStateWatcherFuncs.ON_SOLUTION_CHANGE)


func on_required_formula_type_change():
	if StateHolder == null:
		return
	
	if notify_parent and Parent != null:
		if Parent.has_method(Groups.LockpadStateWatcherFuncs.ON_REQUIRED_FORMULA_TYPE_CHANGE):
			Parent.call(Groups.LockpadStateWatcherFuncs.ON_REQUIRED_FORMULA_TYPE_CHANGE)
	

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_lockpad_state_holder_change(sh:LockpadStateHolder) -> void:
	set_state_holder(sh)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
