class_name InventoryButton extends TextureButton

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

func _input(event:InputEvent):
	
	if not event is InputEventKey:
		return
		
	if event.scancode == KEY_TAB and not event.is_echo() and event.is_pressed():
		_on_InventoryButton_pressed()

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


func _on_InventoryButton_pressed():
	SceneManager.view_case = SceneManager.Cases.INVENTORY \
			if SceneManager.view_case != SceneManager.Cases.INVENTORY \
			else SceneManager.Cases.MAP
