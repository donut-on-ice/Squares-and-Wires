extends "res://src/Watchers/PuzzleIOStateWatcher.gd"
#extends HBoxContainer
class_name RightPanel

#### VARS ####

# enums
# consts

# settings
export(bool) var is_table_folded = false setget set_table_folded

# singletons
# nodes
onready var OTColapseButtonContainer: = $OPM/OP/Panel/CenterOTColapse
onready var OTExpandButtonContainer: = $OPM/OP/Panel/CenterOTExpand
onready var TableBackgroundContainer: = $OTM
onready var TableBackground:TextureRect = $OTM/TBackground

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	update_is_table_folded()


func _notification(n) -> void:
	if (n == self.NOTIFICATION_SORT_CHILDREN):
		var top_left_corner_of_child = \
				this_node.get_combined_minimum_size().x + get_separation()
		for c in get_children():
			if c != null && c.is_visible():
				top_left_corner_of_child -= c.get_size().x + get_separation()
				this_node.fit_child_in_rect(c,
						Rect2(Vector2(top_left_corner_of_child, 0),c.get_size()))
		this_node.set_size(Vector2.ZERO)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_table_folded(b:bool) -> void:
	if is_table_folded == b:
		return
	is_table_folded = b
	update_is_table_folded()


func set_separation(i:int) -> void:
	set("custom_constants/separation", i)


# updates
func update_is_table_folded() -> void:
	if !is_inside_tree():
		return
	TableBackgroundContainer.set_visible(!is_table_folded)
	OTColapseButtonContainer.set_visible(!is_table_folded)
	OTExpandButtonContainer.set_visible(is_table_folded)


func update_table_background() -> void:
	if !is_inside_tree():
		return
	if StateHolder == null:
		return
	
	var i = 0
	var j = 0
	if StateHolder != null:
		i = StateHolder.output_nr - 1
		j = StateHolder.input_nr - 1
	TableBackground.set_texture(PUtils.path_tables[i][j])
	this_node.rect_size = Vector2.ZERO
	TableBackground.rect_size = Vector2.ZERO

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
func get_separation() -> float:
	return get("custom_constants/separation")

### bools ###

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_output_nr_change() -> void:
	if StateHolder == null:
		return
	update_table_background()


func on_input_nr_change() -> void:
	if StateHolder == null:
		return
	update_table_background()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_OTColapse_pressed() -> void:
	set_table_folded(true)


func _on_OTExpand_pressed() -> void:
	set_table_folded(false)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
