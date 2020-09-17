tool
extends BasicButton

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
var popup

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	if Engine.editor_hint:
		return
	
	on_game_slot_change()
	add_to_group(Groups.GAME_STATE_WATCHERS)


func _activate():
	
	if popup == null:
		return
	
	popup.case = PopUp.Cases.RESET
	popup.visible = true

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

func on_game_slot_change():
	self.set_disabled(LevelManager.current_game_slot == LevelManager.Slots.NONE)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
