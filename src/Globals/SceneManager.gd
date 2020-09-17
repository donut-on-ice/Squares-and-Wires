extends Node

#### VARS ####
# enums
enum Cases {
		MENU, # TODO extend
		POPUP, 
		MAP,
		
		SAVE, # TODO create
		LOAD, # TODO create
		NEW_GAME, # TODO create
		
		CONTROL_BOARD, 
		LOCKPAD,
		UPGRADE_TABLE, # TODO create
		INVENTORY,
		
		NONE
	} 

# consts
# settings
# singletons
# nodes
# public
var view_case:int = Cases.NONE setget set_view_case
var info_visible:bool = false setget set_info_visible

# private
var default_mouse_filters := {}

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _unhandled_key_input(event):
	
	if event.is_action_pressed("escape"):
		
		if info_visible:
			set_info_visible(false)
		
		else: match view_case:
		
			Cases.MENU:
				pass
				
			Cases.POPUP, \
			Cases.MAP, \
			Cases.SAVE, \
			Cases.LOAD, \
			Cases.NEW_GAME:
				set_view_case(Cases.MENU)
		
			Cases.CONTROL_BOARD, \
			Cases.UPGRADE_TABLE, \
			Cases.INVENTORY, \
			Cases.LOCKPAD:
				set_view_case(Cases.MAP)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_node_paused(n:Node, paused:bool):
	set_pause_all_process(n, paused)


var deparented_nodes := {}
func deparent_node(n:Node, paused:bool):
	if paused:
		deparented_nodes[n] = n.get_parent()
		n.get_parent().remove_child(n)
	elif deparented_nodes.has(n):
		deparented_nodes[n].add_child(n)
		deparented_nodes.erase(n)


func set_pause_all_process(n:Node, paused:bool):
	match n.pause_mode:
		Node.PAUSE_MODE_PROCESS: paused = false
		Node.PAUSE_MODE_STOP: paused = true
		Node.PAUSE_MODE_INHERIT, _: paused = paused
	
	n.set_process(not paused)
	n.set_process_input(not paused)
	n.set_physics_process(not paused)
	
	
	if n is Control:
		
		if not default_mouse_filters.has(n):
			default_mouse_filters[n] = n.mouse_filter
		
		n.mouse_filter = Control.MOUSE_FILTER_IGNORE \
				if paused \
				else default_mouse_filters[n]
	
	for c in n.get_children():
		set_node_paused(c, paused)


func set_view_case(vc:int):
	
	view_case = vc
	
	get_tree().call_group(Groups.PAUSABLES, 
			Groups.PausableFuncs.ON_VIEW_CASE_CHANGE)


func set_info_visible(b:bool):
	
	info_visible = b
	
	get_tree().call_group(Groups.PAUSABLES, 
			Groups.PausableFuncs.ON_INFO_VISIBLE_CHANGE)

### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
