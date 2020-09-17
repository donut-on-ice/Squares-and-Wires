tool
class_name LabelWithHighlight extends Label


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

func _ready():
	set_process(false)


func _process(_delta:float):
	
	set_size(Vector2.ZERO)
	set_anchors_and_margins_preset(Control.PRESET_CENTER)
	
	if not is_inside_tree():
		return
	
	$left.set_size(Vector2.ZERO)
	$right.set_size(Vector2.ZERO)
	$top.set_size(Vector2.ZERO)
	$bottom.set_size(Vector2.ZERO)
	
	set_process(false)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_text(t:String):
	text = t
	
	if not is_inside_tree():
		return
	
	$left.text = t
	$right.text = t
	$top.text = t
	$bottom.text = t
	set_process(true)


func set_highlight_color(c:Color):
	
	if not is_inside_tree():
		return
	
	$highlight.color = c
	$left.set("custom_colors/font_color", c)
	$right.set("custom_colors/font_color", c)
	$top.set("custom_colors/font_color", c)
	$bottom.set("custom_colors/font_color", c)
	


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

