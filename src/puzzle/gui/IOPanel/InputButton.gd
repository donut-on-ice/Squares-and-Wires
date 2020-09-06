extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends HBoxContainer
class_name InputButton

#### VARS ####

# enums
# consts

# settings
export(int, 1, 4) var index:int = 2 setget set_index

# singletons
# nodes
onready var Center:TextureButton = $Center

# public
# private
var _logic_state:bool = false setget set_logic_state

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	update_button_texture()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_logic_state(b:bool) -> void:
	_logic_state = b
	update_button_texture()


func set_index(i:int) -> void:
	index = i
	update_button_texture()


# updates
func update_button_texture() -> void:
	if !is_inside_tree():
		return
	var i:int
	var j:int
	var k:int
	i = int(_logic_state)
	j = index - 1
	
	k = PUtils.InputPanelButtonStates.IDLE 
	Center.set_normal_texture(PUtils.input_panel_buttons[i][j][k])
	
	k = PUtils.InputPanelButtonStates.HOVERED
	Center.set_hover_texture(PUtils.input_panel_buttons[i][j][k])
	
	k = PUtils.InputPanelButtonStates.CLICKED
	Center.set_pressed_texture(PUtils.input_panel_buttons[i][j][k])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_state_change() -> void:
	if StateHolder == null:
		return
	set_logic_state((StateHolder.input_state >> (index-1) ) % 2 == 1)


func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	this_node.set_visible(index <= StateHolder.input_nr) 

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Center_pressed() -> void:
	if StateHolder == null:
		return
	
	var new_input_state = StateHolder.input_state
	var old_logic_state = _logic_state
	
	if old_logic_state == true:
		new_input_state &= ~(1 << (index - 1)) # set false
	else:
		new_input_state |= 1 << (index - 1) # set true
	
	StateHolder.set_input_state(new_input_state)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#

