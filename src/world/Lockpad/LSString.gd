tool
class_name LSString extends HBoxContainer

#### VARS ####
# enums
# consts
# settings
export(int) var max_length:int = 10 setget set_max_length
export(String) var actual_string:String = "" setget set_actual_string
 
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	set_max_length(max_length)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_max_length(l:int):
	
	max_length = l
	
	if get_child_count() < max_length:
		for _i in range(get_child_count(), max_length):
			add_child(preload("res://Scenes/ToolBoxGUI/Char.tscn").instance())
		
	elif get_child_count() > max_length:
		for _i in range(max_length, get_child_count()):
			get_child(max_length).queue_free()

	set_actual_string(actual_string)


func set_actual_string(s:String):

	actual_string = s.substr(0, max_length)
	
	update_children_textures()


### updates ###
func update_children_textures():
	
	var is_start_white_space := true
	for i in range(get_child_count()):
	
		var ch:LSChar = get_child(i)
		ch.set_character(actual_string[i] if actual_string.length() > i else '')
		is_start_white_space = is_start_white_space and ch.is_white_space() 
		ch.set_visible(!is_start_white_space)
	
	
	if !is_start_white_space:
		
		var is_end_white_space := true
		for i in range(get_child_count() -1, -1, -1):
			
			var ch:LSChar = get_child(i)
			is_end_white_space = is_end_white_space and ch.is_white_space()
			
			if !is_end_white_space:
				break
			
			get_child(i).set_visible(false)
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###
func is_white_space() -> bool:
	
	var it_is := true
	
	for c in get_children():
		it_is = it_is and (c as LSChar).is_white_space()
	
	return it_is


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
