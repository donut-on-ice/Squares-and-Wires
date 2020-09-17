class_name AreYouSurePopUP extends Control

#### VARS ####

# enums
enum Cases {NONE, OVERRIDE_WITH_NEW_GAME, EXIT_AND_SAVE, EXIT}

# consts
const Texts := [
		"",
		"errase\nold game?",
		"save and\nexit game?",
		"exit game?" 
	]

# settings
export(Cases) var case:int = Cases.NONE setget set_case

# singletons
# nodes
onready var Question:Label = $DialogBox/Content/Control/Question

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)
	add_to_group(Groups.MENU_POPUP)
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_case(c:int):
	
	case = c
	
	Question.set_text(Texts[case])


### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.POPUP
	
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():

	var paused := view_case_to_paused(SceneManager.view_case)
	
	if paused:
		set_case(Cases.NONE)
	elif case == Cases.NONE:
		set_case(Cases.EXIT_AND_SAVE if LevelManager.can_save() else Cases.EXIT)
	
	visible = not paused
	
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#


func _on_Yes_pressed():
	match case:
		Cases.OVERRIDE_WITH_NEW_GAME:
			LevelManager.start_new_game()
		Cases.EXIT_AND_SAVE:
			LevelManager.save()
			LevelManager.exit()
		Cases.EXIT:
			LevelManager.exit()


func _on_No_pressed():
	SceneManager.view_case = SceneManager.Cases.MENU
