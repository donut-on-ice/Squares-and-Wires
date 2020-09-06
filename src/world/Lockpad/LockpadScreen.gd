tool
class_name LockpadScreen extends Control

#### VARS ####
# enums
# consts
const char_width = 12
const char_height = 10

# settings
export(bool) var resize:bool = false setget set_resize
export(String) var l0:String = "" setget set_l0
export(String) var l1:String = "" setget set_l1
export(String) var l2:String = "" setget set_l2
export(String) var l3:String = "" setget set_l3

# singletons
# nodes
onready var Text:LSText = $"Display Contour/Display Margin/Display Screen/Screen Margin/Screen Center/Text" setget , get_text_node

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_l0(s:String):
	l0 = s
	set_text()


func set_l1(s:String):
	l1 = s
	set_text()


func set_l2(s:String):
	l2 = s
	set_text()


func set_l3(s:String):
	l3 = s
	set_text()


func set_text():
	
	if Engine.editor_hint:
		return
	
	var t := ""
	
	t += l0
	
	if l1 != null and l1 != "":
		if t != "":
			t += '\n'
		t += l1
	
	if l2 != null and l2 != "":
		if t != "":
			t += '\n'
		t += l2
	
	if l3 != null and l3 != "":
		if t != "":
			t += '\n'
		t += l3
	
	get_text_node().set_text(t)


func set_resize(b:bool):
	
	resize = b
	
	var display_countour:ColorRect = get_child(0)
	var display_margin:MarginContainer = display_countour.get_child(0)
	var display_screen:ColorRect = display_margin.get_child(0)
	var screen_margin:MarginContainer = display_screen.get_child(0)
	var screen_center:CenterContainer = screen_margin.get_child(0)
	var text:LSText = screen_center.get_child(0)
	
	var size := Vector2(
			char_width * text.CHAR_NR,
			char_height * text.LINE_NR
		)
	size.y += text.get("custom_constants/separation") * (text.LINE_NR - 1)
	
	size.x += screen_margin.get("custom_constants/margin_top")
	size.x += screen_margin.get("custom_constants/margin_bottom")
	size.y += screen_margin.get("custom_constants/margin_left")
	size.y += screen_margin.get("custom_constants/margin_right")
	
	display_screen.set_custom_minimum_size(size)
	screen_margin.set_size(size)
	
	size.x += display_margin.get("custom_constants/margin_top")
	size.x += display_margin.get("custom_constants/margin_bottom")
	size.y += display_margin.get("custom_constants/margin_left")
	size.y += display_margin.get("custom_constants/margin_right")
	
	display_countour.set_custom_minimum_size(size)
	screen_center.set_size(Vector2.ZERO)
	
	set_custom_minimum_size(size)
	set_size(Vector2.ZERO)
	
### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_text_node():
	
	if Text == null:
		Text = $"Display Contour/Display Margin/Display Screen/Screen Margin/Screen Center/Text"

	return Text

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
