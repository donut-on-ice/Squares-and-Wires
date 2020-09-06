class_name OTButton extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends TextureButton

#### VARS ####

# enums
# consts

# settings
export(int, 0, 15) var index:int = 0 setget set_index

# singletons
# nodes
onready var Nr:Number = $OTLine/Nr
onready var lights:Array = [
		$OTLine/LightsMargin/Lights/Light1,
		$OTLine/LightsMargin/Lights/Light2,
		$OTLine/LightsMargin/Lights/Light3,
		$OTLine/LightsMargin/Lights/Light4
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


func update_req_out_ls_lights() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	#req_out_states[1:s, 2:s, 3:s, 4:s] s = short 16 biti
	for i in range(4):
		var required_logic_state = StateHolder.required_output_states[i]
		required_logic_state = required_logic_state >> (index * 2)
		required_logic_state = required_logic_state % 4
		lights[i].set_required_logic_state(required_logic_state == PuzzleIOStateHolder.Values.TRUE)
		# 00 - innactive
		# 01 - false
		# 10 - true
		# 11 - error 


func update_ls_lights() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	# states[1:[sf, st], 2:[sf, st], 3:[sf,st], 4:[sf, st]]
	# sf = short false
	# st = short true
	for i in range(4):
		var false_true:int = StateHolder.output_states[i]
		false_true = false_true >> (index * 2)
		false_true = false_true & 0x03
		lights[i].set_false_true(false_true)


func update_input_nr() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	Nr.set_hide_decimal_zero(StateHolder.input_nr != 4)
	udpate_shade_textures()
	this_node.set_visible(index<(1<<StateHolder.input_nr))


func update_output_nr() -> void:
	if StateHolder == null:
		return
	lights[4-1].set_visible(StateHolder.output_nr >= 4)
	lights[3-1].set_visible(StateHolder.output_nr >= 3)
	lights[2-1].set_visible(StateHolder.output_nr >= 2)
	lights[1-1].set_visible(StateHolder.output_nr >= 1)
	udpate_shade_textures()


func udpate_shade_textures() -> void:
	if !is_inside_tree():
		return
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
	update_input_nr()


func on_output_nr_change() -> void:
	if StateHolder == null:
		return
	update_output_nr()


func on_output_states_change() -> void:
	if StateHolder == null:
		return
	update_ls_lights()


func on_required_output_states_change() -> void:
	if StateHolder == null:
		return
	update_req_out_ls_lights()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_OTButton_button_down() -> void:
	if StateHolder == null:
		return
	StateHolder.set_input_state(index)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
