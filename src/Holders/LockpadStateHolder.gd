class_name LockpadStateHolder extends Control

#### VARS ####

# enums
enum Type {NO_TYPE, SIGMA_TYPE, PI_TYPE} 

# consts
# settings
# singletons
# nodes
onready var Enter:LockpadEnterKey = $Background/Panel/KepadBackground/Keys/Enter
onready var Screen:LockpadScreen = $Background/Panel/Screen
var current_toolbox:ToolBox setget set_current_toolbox

# public
var solution:int = 0 setget set_solution

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	Enter.type = LockpadEnterKey.Types.NONE
	
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME,
			Groups.LOCKPAD_STATE_HOLDERS,
			Groups.LockpadStateHolderFuncs.ON_LOCKPAD_STATE_HOLDER_CHANGE)
	add_to_group(Groups.LOCKPAD_STATE_HOLDERS)
	get_tree().call_group(Groups.LOCKPAD_STATE_WATCHERS,
			Groups.LockpadStateWatcherFuncs.ON_LOCKPAD_STATE_HOLDER_CHANGE,
			self)
	
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_current_toolbox(ct:ToolBox):
	
	current_toolbox = ct
	set_solution(0)
	Enter.type = current_toolbox.required_formula_type
	Screen.Text.set_text(current_toolbox.hint_formula)
	set_visible(true)
	

func set_solution_bit(bit:int, value:bool):
	
	if value:
		solution |= 1 << bit
	else:
		solution &= ~(1 << bit) 
	
	update_solution_watchers()


func set_solution(s:int):
	
	solution = s 
	
	update_solution_watchers()


### updates ###
func update_solution_watchers():
	if !is_inside_tree():
		return
	
	get_tree().call_group(Groups.LOCKPAD_STATE_WATCHERS,
			Groups.LockpadStateWatcherFuncs.ON_SOLUTION_CHANGE)


func send_solution():
	
	if current_toolbox == null:
		return 
	
	current_toolbox.process_solution(solution)
	current_toolbox = null

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_solution_bit(bit:int) -> bool:
	return (solution >> bit) & 1 == 1


### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.LOCKPAD

### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

# PausableFuncs
func on_view_case_change():
	
	var paused := view_case_to_paused(SceneManager.view_case)
	
	if visible and paused:
		send_solution()
	visible = not paused
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)


# LockapadStateHolderFuncs
func on_lockpad_state_holder_change() -> void:
	remove_from_group(Groups.LOCKPAD_STATE_HOLDERS)


func on_node_is_ready(n:Node) -> void:
	if n.has_method(Groups.LockpadStateWatcherFuncs.ON_LOCKPAD_STATE_HOLDER_CHANGE):
		n.call(Groups.LockpadStateWatcherFuncs.ON_LOCKPAD_STATE_HOLDER_CHANGE, self)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
