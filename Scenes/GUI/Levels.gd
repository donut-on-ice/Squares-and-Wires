tool
extends BasicButton

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
var menu

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	pass


func _activate():
	if menu == null:
		return
	
	menu.subcase = Menu.Subcases.LEVELS

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
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
