class_name MenuCamera extends Camera2D

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
	current = true if not Menu.view_case_to_paused(SceneManager.view_case) else current
	pause_mode = Node.PAUSE_MODE_STOP \
			if current \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, current)
	
	
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
