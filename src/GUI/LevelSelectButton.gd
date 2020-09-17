tool
extends BasicButton

#### VARS ####
# enums
# consts
# settings
export(int) var level:int = 1 setget set_level
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	pass


func _activate():
	LevelManager.start_level(level)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_level(i:int):
	level = i
	if i > 0:
		name = str(i)
		set_text(str(i))

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
