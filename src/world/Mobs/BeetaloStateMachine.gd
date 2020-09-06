class_name BeetaloStateMachine
extends AnimationTree

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
onready var state_machine:AnimationNodeStateMachinePlayback = get("parameters/playback")

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_all_blend_positions(p:Vector2) -> void:
	set("parameters/Charge/blend_position", p)
	set("parameters/Dying/blend_position", p)
	set("parameters/Hit/blend_position", p)
	set("parameters/Idle/blend_position", p)
	set("parameters/Walk/blend_position", p)
	set("parameters/Wind Up/blend_position", p)

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
