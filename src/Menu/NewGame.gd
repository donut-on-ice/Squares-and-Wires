class_name NewGame extends TextureButton

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
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


func _on_NewGame_pressed():
	
		
	if LevelManager.current_game_slot == LevelManager.Slots.NONE:
		LevelManager.current_game_slot = LevelManager.Slots.FIRST
		LevelManager.start_new_game()
	else:
		LevelManager.current_game_slot = LevelManager.Slots.FIRST
		get_tree().call_group(Groups.MENU_POPUP,
				Groups.MenuPopupFuncs.SET_CASE,
				AreYouSurePopUP.Cases.OVERRIDE_WITH_NEW_GAME)
		SceneManager.view_case = SceneManager.Cases.POPUP
