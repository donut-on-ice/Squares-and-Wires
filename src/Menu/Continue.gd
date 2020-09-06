class_name Continue extends TextureButton

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

func _ready():
	on_game_slot_change()
	add_to_group(Groups.GAME_STATE_WATCHERS)
	
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

## GameStateWatcherFuncs
func on_game_slot_change():
	set_disabled(LevelManager.current_game_slot == LevelManager.Slots.NONE)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Continue_pressed():
	LevelManager.continue_game()
	
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
