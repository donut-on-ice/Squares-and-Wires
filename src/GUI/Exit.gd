tool
class_name Exit extends BasicButton

#### VARS ####
# enums
# consts
const Texts := {
	SAVE_AND_EXIT = "SAVE & EXIT",
	EXIT = "EXIT"
}

# settings
export(bool) var can_save:bool = false setget set_can_save

# singletons
# nodes
var popup

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	on_level_id_change()
	add_to_group(Groups.GAME_STATE_WATCHERS)
	set_text(Texts.SAVE_AND_EXIT if can_save else Texts.EXIT)


func _activate():
	
	if popup == null:
		return
	
	popup.case = PopUp.Cases.EXIT_AND_SAVE if can_save else PopUp.Cases.EXIT
	popup.visible = true

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_can_save(b:bool):
	can_save = b
	set_text(Texts.SAVE_AND_EXIT if can_save else Texts.EXIT)

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

func on_level_id_change():
	set_can_save(LevelManager.CurrentLevel != null)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
