tool
class_name NewGame extends BasicButton

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
	pass

func _activate():
	
	if popup == null:
		return
	
	if LevelManager.current_game_slot == LevelManager.Slots.NONE:
		LevelManager.current_game_slot = LevelManager.Slots.FIRST
		LevelManager.start_new_game()
	else:
		LevelManager.current_game_slot = LevelManager.Slots.FIRST
		popup.case = PopUp.Cases.OVERRIDE_WITH_NEW_GAME
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
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
