extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends HBoxContainer
class_name LeftPanel

#### VARS ####

# enums
# consts

# settings
export(bool) var is_table_folded = true setget set_table_folded

# singletons

# nodes
onready var ITColapseButtonContainer: = $IPMargin/IP/Panel/CenterITColapse
onready var ShownNumberLeftMargin: = $IPMargin/IP/CenterNr/Left
onready var ITExpandButtonContainer: = $IPMargin/IP/Panel/CenterITExpand
onready var TableBackgroundContainer: = $ITM
onready var TableBackground:TextureRect = $ITM/TBackground
onready var SelectedNr:Number = $IPMargin/IP/CenterNr/NrBackground/SelectedNr

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	update_is_table_folded()
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_table_folded(b:bool) -> void:
	is_table_folded = b
	update_is_table_folded()



# updates
func update_is_table_folded() -> void:
	TableBackgroundContainer.set_visible(!is_table_folded)
	ITColapseButtonContainer.set_visible(!is_table_folded)
	ShownNumberLeftMargin.set_visible(!is_table_folded)
	ITExpandButtonContainer.set_visible(is_table_folded)


func update_table_background() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return

	var i = 0
	var j = 0
	if StateHolder != null:
		i = StateHolder.input_nr - 1
		j = StateHolder.input_nr - 1
	TableBackground.set_texture(PUtils.path_tables[i][j])
	this_node.rect_size = Vector2.ZERO
	TableBackground.rect_size = Vector2.ZERO

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_state_change() -> void:
	if StateHolder == null:
		return
	SelectedNr.set_number(StateHolder.input_state)


func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	update_table_background()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_ITColapse_pressed() -> void:
	set_table_folded(true)


func _on_ITExpand_pressed() -> void:
	set_table_folded(false)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#


