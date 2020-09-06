extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends TextureButton
class_name ITButton

#### VARS ####

# enums
# consts

# settings
export(int, 0, 15) var index:int = 0 setget set_index

# singletons
# nodes
onready var Nr:Number = $ITLine/Nr
onready var lights:Array = [
		$ITLine/LightsMargin/Lights/Light1,
		$ITLine/LightsMargin/Lights/Light2,
		$ITLine/LightsMargin/Lights/Light3,
		$ITLine/LightsMargin/Lights/Light4
	]

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	update_index()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_index(i:int) -> void:
	index = i
	update_index()


# updates
func update_index() -> void:
	if !is_inside_tree():
		return
	Nr.set_number(index)
	set_lights()


func set_lights() -> void:
	lights[0].set_true((index>>0)%2 == 1)
	lights[1].set_true((index>>1)%2 == 1)
	lights[2].set_true((index>>2)%2 == 1)
	lights[3].set_true((index>>3)%2 == 1)
	
	
func update_visible_lights() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	Nr.set_hide_decimal_zero(StateHolder.input_nr != 4)
	lights[3].set_visible(StateHolder.input_nr >= 4)
	lights[2].set_visible(StateHolder.input_nr >= 3)
	lights[1].set_visible(StateHolder.input_nr >= 2)
	lights[0].set_visible(StateHolder.input_nr >= 1)
	update_textures()
	this_node.set_visible(index<(1<<StateHolder.input_nr))


func update_textures() -> void:
	var i = int(!Nr.hide_decimal_zero)
	var j = get_visible_lights_count() - 1
	this_node.set_pressed_texture(
			PUtils.path_button_masks[PUtils.MaskType.SELECTED][i][j])
	this_node.set_normal_texture(
			PUtils.path_button_masks[PUtils.MaskType.EMPTY][i][j])
	this_node.set_hover_texture(
			PUtils.path_button_masks[PUtils.MaskType.HOVERED][i][j])
	this_node.set_disabled_texture(
			PUtils.path_button_masks[PUtils.MaskType.SELECTED][i][j])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
func get_visible_lights_count() -> int:
	var c:int = 0
	for l in lights:
		c += int(l.is_visible())
	return c

### bools ###

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_input_state_change() -> void:
	if StateHolder == null:
		return
	if StateHolder.input_state == index:
		this_node.set_pressed(true)
		this_node.set_disabled(true)
	else:
		this_node.set_disabled(false)
		this_node.set_pressed(false)


func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	update_visible_lights()
	
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_ITButton_button_down() -> void:
	if StateHolder == null:
		return
	StateHolder.set_input_state(index)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
