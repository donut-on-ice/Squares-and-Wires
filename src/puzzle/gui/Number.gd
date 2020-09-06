class_name Number extends HBoxContainer


#### VARS ####

# enums
# consts

# settings
export(int, 0, 99) var number:int = 0 setget set_number
export(bool) var use_space_for_decimal_zero:bool = false setget set_use_space_for_decimal_zero
export(bool) var hide_decimal_zero:bool = false setget set_hide_decimal_zero
export(bool) var is_just_space:bool = false setget set_just_space

# singletons

# nodes
onready var _f_digit:Digit = $FirstDigit
onready var _s_digit:Digit =  $SecondDigit

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	update_number()
	update_use_space_for_decimal_zero()
	update_hide_decimal_zero()
	update_is_just_space()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_number(i:int) -> void:
	number = i
	update_number()


func set_use_space_for_decimal_zero(b:bool) -> void:
	use_space_for_decimal_zero = b
	update_use_space_for_decimal_zero()


func set_hide_decimal_zero(b:bool) -> void:
	hide_decimal_zero = b
	update_hide_decimal_zero()


func set_just_space(b:bool) -> void:
	is_just_space = b
	update_is_just_space()


# updates
func update_number() -> void:
	if !is_inside_tree():
		return
	
	if number < 0 or is_just_space:
		_f_digit.set_digit(0)
		_s_digit.set_digit(0)
	elif number > 99:
		_f_digit.set_digit(9)
		_s_digit.set_digit(9)
	else:
		_f_digit.set_digit(number/10)
		_s_digit.set_digit(number%10)
	
	update_hide_decimal_zero()


func update_use_space_for_decimal_zero() -> void:
	if !is_inside_tree():
		return
	if is_just_space:
		use_space_for_decimal_zero = true
	_f_digit.set_use_space_on_zero(use_space_for_decimal_zero)


func update_hide_decimal_zero() -> void:
	if !is_inside_tree():
		return
	_f_digit.set_visible(!(hide_decimal_zero and number < 10))


func update_is_just_space() -> void:
	if !is_inside_tree():
		return
	_f_digit.set_use_space_on_zero(is_just_space or use_space_for_decimal_zero)
	_s_digit.set_use_space_on_zero(is_just_space)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
