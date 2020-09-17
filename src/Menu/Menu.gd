class_name Menu extends Control

#### VARS ####

# enums
enum Subcases {MAIN, LEVELS}

# consts
# settings
# singletons
# nodes
# public
var subcase:int = Subcases.MAIN setget set_subcase

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	$PopUp.menu = self
	$Main/Margin/Margin/Buttons/Levels.menu = self
	$Main/Margin/Margin/Buttons/Reset.popup = $PopUp
	$Main/Margin/Margin/Buttons/NewGame.popup = $PopUp
	$Main/Margin/Margin/Buttons/Exit.popup = $PopUp
	
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)
	set_subcase(subcase)

func _unhandled_key_input(event):
	
	if not is_inside_tree():
		return
	
	if event.is_action_pressed("escape"):
		if SceneManager.view_case == SceneManager.Cases.MENU:
			match subcase:
				Subcases.LEVELS:
					set_subcase(Subcases.MAIN)
				Subcases.MAIN:
					$Main/Margin/Margin/Buttons/Exit._activate()
				
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_subcase(i:int):
	subcase = i
	
	if not is_inside_tree():
		return
	
	$Main.visible = subcase == Subcases.MAIN
	$LevelSelect.visible = subcase == Subcases.LEVELS

### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return SceneManager.Cases.MENU != vc \
			and SceneManager.Cases.POPUP != vc

### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	var paused := view_case_to_paused(SceneManager.view_case)
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
