extends TextureRect
class_name OutputRight

#### VARS ####

# enums
enum States {FALSE, TRUE}

# consts

# settings
var required_logic_state:bool = false setget set_required_logic_state

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
func set_required_logic_state(b:bool) -> void:
	required_logic_state = b
	update_light()


# updates
func update_light() -> void:
	if !is_inside_tree():
		return
	set_texture(PUtils.paths_required_output_ls[int(required_logic_state)])

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

