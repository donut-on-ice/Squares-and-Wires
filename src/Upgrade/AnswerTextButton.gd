tool
class_name AnswerTextButton extends Label

#### VARS ####
# enums
# consts
const IDLE_COLOR = Color("a2ff99")
const HOVERED_COLOR = Color("ffee83")
const RIGHT_COLOR = Color("7ad5ff")
const WRONG_COLOR = Color("ff5980")

# settings
export(int, 1, 8) var index:int = 1 setget set_index

# singletons
# nodes
var ParentGUI = null

# public
var answer:String = "" setget set_answer
var right_answer:bool = false
var disabled:bool = true setget set_disabled

# private
var hovered := false

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	reset()


func _input(event:InputEvent):
	
	if not visible or disabled:
		return
	
	if event is InputEventMouseMotion:
		update_color()
	
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("set") and has_mouse():
			if is_hovered() and ParentGUI.pressed_index == 0:
					ParentGUI.pressed_index = index

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func reset():
	answer = ""
	text = char(0x30 + index) + "> " + answer
	right_answer = false
	update_color()


func set_index(i:int):
	index = max(1, min(i, 8))
	text = char(0x30 + index) + text.right(1)


func set_answer(a:String):
	answer = a
	text = text.left(3) + answer


func set_disabled(b:bool):
	disabled = b
	update_color()


### updates ###
func update_color():
	
	if disabled:
		
		if ParentGUI == null or ParentGUI.pressed_index == 0:
			set("custom_colors/font_color", IDLE_COLOR)

		else:
			set("custom_colors/font_color", RIGHT_COLOR if right_answer \
					else WRONG_COLOR if ParentGUI.pressed_index == index \
						else IDLE_COLOR)
	
	elif has_mouse():
		if not is_hovered():
			set("custom_colors/font_color", HOVERED_COLOR)

	else:
		if not is_idle():
			set("custom_colors/font_color", IDLE_COLOR)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###
func is_hovered() -> bool:
	return get("custom_colors/font_color") == HOVERED_COLOR


func is_idle() -> bool:
	return get("custom_colors/font_color") == IDLE_COLOR


func has_point(point:Vector2) -> bool:

	var start := get_global_position()
	var end:Vector2 = start + get_size() * get_scale()
	
	return point.x > start.x and point.y > start.y \
		and point.x < end.x and point.y < end.y


func has_mouse() -> bool:
	return has_point(get_viewport().get_mouse_position())


static func compare(a:AnswerTextButton, b:AnswerTextButton):
	return a.index < b.index

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
