class_name PuzzleLayerWatcher extends Node

#### VARS ####
# enums
# consts
# settings
# singletons

# nodes
var LayerHolder:PuzzleLayerHolder setget set_layer_holder
var this_node = self

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	add_to_group(Groups.PUZZLE_LAYER_WATCHERS)
	get_tree().call_group(Groups.PUZZLE_LAYER_HOLDERS,
			Groups.PuzzleLayerHolderFuncs.ON_NODE_IS_READY,
			self)
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_layer_holder(plh:PuzzleLayerHolder) -> void:
	LayerHolder = plh
	update_layer_holder()


# updates
func update_layer_holder() -> void:
	if !is_inside_tree():
		return

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_layer_holder_change(plh:PuzzleLayerHolder) -> void:
	set_layer_holder(plh)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
