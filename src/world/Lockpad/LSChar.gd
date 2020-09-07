tool
class_name LSChar extends TextureRect

#### VARS ####
# enums
# consts
const Skins := {
		# operators
		'&': preload("res://assets/ui/lockpad/display/and.png"),
		'*': preload("res://assets/ui/lockpad/display/and.png"),
		'|': preload("res://assets/ui/lockpad/display/or.png"),
		'+': preload("res://assets/ui/lockpad/display/or.png"),
		'^': preload("res://assets/ui/lockpad/display/xor.png"),
		'!': preload("res://assets/ui/lockpad/display/not.png"),
		'>': preload("res://assets/ui/lockpad/display/imply.png"),
		'=': preload("res://assets/ui/lockpad/display/equal.png"),
		'/': preload("res://assets/ui/lockpad/display/not_equal.png"),
		'S': preload("res://assets/ui/lockpad/display/sum_of_products.png"),
		'P': preload("res://assets/ui/lockpad/display/product_of_sums.png"),
		
		# semantics
		',': preload("res://assets/ui/lockpad/display/comma.png"),
		' ': preload("res://assets/ui/lockpad/display/space.png"),
		'(': preload("res://assets/ui/lockpad/display/bracket_round_start.png"),
		')': preload("res://assets/ui/lockpad/display/bracket_round_end.png"),
		
		# elements
		'0': preload("res://assets/ui/lockpad/display/0.png"),
		'1': preload("res://assets/ui/lockpad/display/1.png"),
		'2': preload("res://assets/ui/lockpad/display/2.png"),
		'3': preload("res://assets/ui/lockpad/display/3.png"),
		'4': preload("res://assets/ui/lockpad/display/4.png"),
		'5': preload("res://assets/ui/lockpad/display/5.png"),
		'6': preload("res://assets/ui/lockpad/display/6.png"),
		'7': preload("res://assets/ui/lockpad/display/7.png"),
		'8': preload("res://assets/ui/lockpad/display/8.png"),
		'9': preload("res://assets/ui/lockpad/display/9.png"),
		'a': preload("res://assets/ui/lockpad/display/a.png"),
		'A': preload("res://assets/ui/lockpad/display/a.png"),
		'b': preload("res://assets/ui/lockpad/display/b.png"),
		'B': preload("res://assets/ui/lockpad/display/b.png"),
		'c': preload("res://assets/ui/lockpad/display/c.png"),
		'C': preload("res://assets/ui/lockpad/display/c.png"),
		'd': preload("res://assets/ui/lockpad/display/d.png"),
		'D': preload("res://assets/ui/lockpad/display/d.png"),
		'e': preload("res://assets/ui/lockpad/display/e.png"),
		'E': preload("res://assets/ui/lockpad/display/e.png"),
		'f': preload("res://assets/ui/lockpad/display/f.png"),
		'F': preload("res://assets/ui/lockpad/display/f.png"),
		
		'w': preload("res://assets/ui/lockpad/display/i1.png"),
		'W': preload("res://assets/ui/lockpad/display/i1.png"),
		'x': preload("res://assets/ui/lockpad/display/i2.png"),
		'X': preload("res://assets/ui/lockpad/display/i2.png"),
		'y': preload("res://assets/ui/lockpad/display/i3.png"),
		'Y': preload("res://assets/ui/lockpad/display/i3.png"),
		'z': preload("res://assets/ui/lockpad/display/i4.png"),
		'Z': preload("res://assets/ui/lockpad/display/i4.png")
	}

# settings
export(String) var character:String = '' setget set_character

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
func _init(c:String = ''):
	set_character(c)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_character(s:String):
	
	character = '' if s.length() == 0 else s[0]
	character = character if Skins.has(character) else ''
	
	update_textures()
	
	
### updates ###
func update_textures():
	set_texture(Skins[character] if Skins.has(character) else Skins[' '])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###
func is_white_space() -> bool:
	return character == null or character == '' or character == ' ' 

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
