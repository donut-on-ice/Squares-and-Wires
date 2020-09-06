class_name BitMaskShape extends TextureRect

#### VARS ####
# enums
# consts
# settings
export(BitMap) var bitmask:BitMap = null

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventMouse:
		if has_point(event.global_position):
			accept_event()
			
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
# setters
# updates
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###

# WE ASUME THAT:
#		1) BitMap and Texture are equal in size
#		2) BitMap and Texture are not fliped
func has_point(global_point:Vector2) -> bool:
	
	var rect_scaled_size:Vector2 = Vector2(rect_size.x * rect_scale.x, rect_size.y * rect_scale.y)
	
	# check if point is inside TextureRect
	if !Rect2(rect_position, rect_scaled_size).has_point(global_point):
		return false;
	
	elif bitmask == null:
		return true
	
	var local_point:Vector2 = global_point
	local_point -= rect_position
	local_point /= rect_scale
	
	# wierd size error fix
	if int(local_point.x) < 0 or int(bitmask.get_size().x) - 1 <= int(local_point.x) \
			or int(local_point.y) < 0 or int(bitmask.get_size().y) - 1 <= int(local_point.y) :
		return false
	
	return bitmask.get_bit(local_point);
	
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
