class_name MapGUI extends MarginContainer

#### VARS ####

# enums
# consts
# settings
export(Color) var HOVERED_COLOR:Color = Color(1.0, 1.0, 1.0, 0.9)
export(Color) var IDLE_COLOR:Color = Color(1.0, 1.0, 1.0, 0.6)

# singletons
# nodes
# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	modulate = IDLE_COLOR
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)


func _input(event:InputEvent) -> void:
	
	if not visible:
		return
	
	if event is InputEventMouseMotion:
		modulate = HOVERED_COLOR \
				if has_point(get_viewport().get_mouse_position()) \
				else IDLE_COLOR

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###
func has_point(point:Vector2) -> bool:
	
	var start := get_global_position()
	var end:Vector2 =  start + rect_size * rect_scale
	
	return point.x > start.x and point.y > start.y \
		and point.x < end.x and point.y < end.y


static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.INVENTORY \
			and vc != SceneManager.Cases.LOCKPAD \
			and vc != SceneManager.Cases.MAP \
			and vc != SceneManager.Cases.UPGRADE_TABLE

### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	var paused:bool = view_case_to_paused(SceneManager.view_case)
	visible = not paused
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_InventoryButton_mouse_entered():
	modulate = HOVERED_COLOR \
			if has_point(get_viewport().get_mouse_position()) \
			else IDLE_COLOR


func _on_InventoryButton_mouse_exited():
	modulate = HOVERED_COLOR \
			if has_point(get_viewport().get_mouse_position()) \
			else IDLE_COLOR

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
