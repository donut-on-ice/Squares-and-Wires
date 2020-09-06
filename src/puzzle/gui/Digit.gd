extends TextureRect
class_name Digit

onready var PUtils: = get_node("/root/PUtils")

export(bool) var use_space_on_zero:bool = false setget set_use_space_on_zero
export(int, 0, 9) var digit:int = 1 setget set_digit


func _ready() -> void:
	update_use_space_on_zero()
	update_digit()


func set_digit(i:int) -> void:
	digit = i
	update_digit()


func set_use_space_on_zero(b:bool) -> void:
	use_space_on_zero = b
	update_use_space_on_zero()
	
	
func update_digit() -> void:
	if !is_inside_tree():
		return
	if use_space_on_zero && digit == 0:
		set_texture(PUtils.path_digits[10])
	else:
		var i = digit%PUtils.path_digits.size()
		set_texture(PUtils.path_digits[i])
	
func update_use_space_on_zero() -> void:
	if !is_inside_tree():
		return
	if use_space_on_zero && digit == 0:
		set_texture(PUtils.path_digits[10])
