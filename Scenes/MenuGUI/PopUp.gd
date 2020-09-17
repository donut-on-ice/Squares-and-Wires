class_name PopUp extends ColorRect

#### VARS ####

# enums
enum Cases {
		NONE,
		RESET,
		OVERRIDE_WITH_NEW_GAME,
		EXIT_AND_SAVE,
		EXIT
	}

# consts
const Texts := [
		"",
		"errase\nold data?",
		"errase\nold game?",
		"save and\nexit game?",
		"exit game?" 
	]

# settings
export(Cases) var case:int = Cases.NONE setget set_case

# singletons
# nodes
onready var Question:Label = $Center/Margin/Margin/Content/Question
var menu

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	$Center/Margin/Margin/Content/Buttons/Yes.popup = self
	$Center/Margin/Margin/Content/Buttons/No.popup = self

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_case(c:int):
	
	case = c
	
	if not is_inside_tree():
		return
	
	Question.set_text(Texts[case])

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
