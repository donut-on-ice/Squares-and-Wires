extends TextureRect
class_name OutputLightLeft

#### VARS ####

# enums
# consts

# settings
var is_false_true:int = 0x00 setget set_false_true

# singletons
# nodes
# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_false_true(ft:int) -> void:
	is_false_true = ft
	update_light()


# updates
func update_light() -> void:
	if !is_inside_tree():
		return
	set_texture(PUtils.paths_output_ls[is_false_true])

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
