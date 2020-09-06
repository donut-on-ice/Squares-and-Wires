class_name Menu extends Control

#### VARS ####

# enums
# consts
# settings
# singletons
# nodes

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return SceneManager.Cases.MENU != vc \
			and SceneManager.Cases.POPUP != vc

### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	var paused := view_case_to_paused(SceneManager.view_case)
	visible = not paused
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
