tool
extends BasicButton

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
var popup

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	pass


func _activate():
	
	if popup == null:
		return
	
	match popup.case:
		PopUp.Cases.RESET:
			LevelManager.reset_levels()
		PopUp.Cases.OVERRIDE_WITH_NEW_GAME:
			LevelManager.start_new_game()
		PopUp.Cases.EXIT_AND_SAVE:
			LevelManager.save()
			LevelManager.exit()
		PopUp.Cases.EXIT:
			LevelManager.exit()
	
	popup.visible = false

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
