class_name InventoryUpdatePopUpManager extends VBoxContainer

#### VARS ####
# enums
# consts
const PopUpTemplate:PackedScene = preload("res://Scenes/MapGUI/InventoryUpdatePopUp.tscn")

# settings
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)

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

func on_addition(components:Array, ups:Array):
	
	for i in range(components.size()):
		
		if components[i] > 0:
		
			var PopUp:InventoryUpdatePopUp = PopUpTemplate.instance()
			add_child(PopUp)
			PopUp.type = InventoryUpdatePopUp.pop_up_type_from_array_pos(i)
			PopUp.quantity = components[i]
	
	for t in Upgrade.Types.values():
		
		var quantity := 0
		
		for up in ups:
			quantity += 1 if up.type == t else 0
		
		if quantity > 0:
		
			var PopUp:InventoryUpdatePopUp = PopUpTemplate.instance()
			add_child(PopUp)
			PopUp.type = InventoryUpdatePopUp.pop_up_type_from_upgrade_type(t)
			PopUp.quantity = quantity


func on_view_case_change():
	if MapGUI.view_case_to_paused(SceneManager.view_case):
		for c in get_children():
			c.queue_free()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
