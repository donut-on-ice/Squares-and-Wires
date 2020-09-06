class_name HealthBarMiddle extends HBoxContainer

#### VARS ####
# enums
# consts
const PointTextures := [
		preload("res://assets/ui/map/battery_icon_middle_empty.png"),
		preload("res://assets/ui/map/battery_icon_middle_full.png")
	]

# settings
export(int) var max_health:int = 0 setget set_max_health
export(int) var current_health:int = 0 setget set_current_health

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_max_health(mh:int):
	max_health = max(0, mh)
	update_children()


func set_current_health(ch:int):
	current_health = min(max_health, ch)
	update_children()

	
### updates ###
func update_children():
	
	if get_child_count() < max_health:
		for _i in range(get_child_count(), max_health):
			var point := TextureRect.new()
			add_child(point)
			point.use_parent_material = true
	else:
		for i in range(get_child_count() - 1, max_health - 1, -1):
			var point:TextureRect = get_child(i)
			point.queue_free()
			remove_child(point)
	
	for i in range(max_health):
		var c:TextureRect =  get_child(i)
		c.set_texture(PointTextures[int(max_health > i)])
		c.mouse_filter = MOUSE_FILTER_IGNORE
		c.use_parent_material = true

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
