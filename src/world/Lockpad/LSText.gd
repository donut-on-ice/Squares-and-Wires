class_name LSText extends VBoxContainer

#### VARS ####
# enums
# consts

# settings
export(int) var max_height:int = 4 setget set_max_height
export(int) var max_width:int = 10 setget set_max_width
export(String) var text:String = "" setget set_text
var splitted_text := PoolStringArray()

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	set_max_height(max_height)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_max_height(h:int):
	
	max_height = h
	
	if get_child_count() < max_height:
		for i in range(get_child_count(), max_height):
			var c:LSString = preload("res://Scenes/ToolBoxGUI/String.tscn").instance()
			c.max_length = max_width
			c.actual_string = splitted_text[i] if i < splitted_text.size() else ""
			add_child(preload("res://Scenes/ToolBoxGUI/String.tscn").instance())
		
	elif get_child_count() > max_height:
		for _i in range(max_height, get_child_count()):
			get_child(max_height).queue_free()


func set_max_width(w:int):
	
	max_width = w
	
	for i in range(get_child_count()):
		var c:LSString = get_child(i)
		c.max_length = max_width
		c.actual_string = splitted_text[i] if i < splitted_text.size() else ""


func set_text(t:String):
	
	splitted_text = t.split('\n', true, get_child_count())
	text = splitted_text.join('\n')
	
	for i in range(get_child_count()):
		var lsstr:LSString = get_child(i)
		lsstr.actual_string = splitted_text[i] if i < splitted_text.size() else ""
	
	update_children_visibility()


### updates ###
func update_children_visibility():
	
	var is_start_white_space := true
	for i in range(get_child_count()):
	
		var lsstr:LSString = get_child(i)
		lsstr.set_actual_string(splitted_text[i] if splitted_text.size() > i else "")
		is_start_white_space = is_start_white_space and lsstr.is_white_space() 
		lsstr.set_visible(!is_start_white_space)
	
	
	if !is_start_white_space:
		
		var is_end_white_space := true
		for i in range(get_child_count() -1, -1, -1):
			
			var lsstr:LSString = get_child(i)
			is_end_white_space = is_end_white_space and lsstr.is_white_space()
			
			if !is_end_white_space:
				break
			
			get_child(i).set_visible(false)

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
