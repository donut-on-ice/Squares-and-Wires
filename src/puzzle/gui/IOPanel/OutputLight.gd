extends HBoxContainer
class_name OutputLight

#### VARS ####

# enums
# consts
# settings
# singletons
# nodes
onready var Left = get_node("Left")
onready var Right = get_node("Right")

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_required_logic_state(b:bool) -> void:
	if Right != null:
		Right.set_required_logic_state(b)


func set_false_true(ft:int) -> void:
	if Left != null:
		Left.set_false_true(ft)


# updates

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
