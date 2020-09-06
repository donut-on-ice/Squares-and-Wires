class_name ShineTimer extends Timer

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
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	paused = Level.view_case_to_paused(SceneManager.view_case)
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_ShineTimer_timeout():
	get_tree().call_group(Groups.SHINERS, Groups.ShinersFuncs.START_SHINING)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
