extends TextureRect
class_name InputLight

#### VARS ####

# enums
# consts

# settings
export(bool) var is_true:bool = false setget set_true

# singletons
onready var PUtils: = get_node("/root/PUtils")

# nodes
# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_true(b:bool) -> void:
	is_true = b
	update_is_true()
	
	
# updates
func update_is_true() -> void:
	if !is_inside_tree():
		return
	set_texture(PUtils.paths_input_ls[int(is_true)])

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
