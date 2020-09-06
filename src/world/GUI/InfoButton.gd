class_name InfoButton extends TextureButton

#### VARS ####
# enums
# consts
const Texts := { # TODO add texts for each case
		SceneManager.Cases.NONE: null,
		SceneManager.Cases.MAP: null,
		SceneManager.Cases.CONTROL_BOARD: null,
		SceneManager.Cases.LOCKPAD: null,
		SceneManager.Cases.UPGRADE_TABLE: null,
		SceneManager.Cases.INVENTORY: null
	}

# settings
# singletons
# nodes
onready var InfoText:Control # TODO add info text object

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)


func _unhandled_input(event:InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		
		modulate = Color(1.0, 1.0, 1.0, 0.8) \
				if has_point((event as InputEventMouseMotion).global_position) \
				else Color(1.0, 1.0, 1.0, 0.5)
		
		if has_point((event as InputEventMouseMotion).global_position):
			accept_event()
			
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_text(_case:int):
	pass # TODO

### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###

### bools ###
func has_point(point:Vector2) -> bool:
	
	var start := get_global_position()
	var end:Vector2 = start + get_size() * get_scale()
	
	return point.x > start.x and point.y > start.y \
		and point.x < end.x and point.y < end.y

### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_info_visible_change():
	return # TODO
	#InfoText.visible = SceneManager.info_visible


func on_view_case_change():
	var paused = Level.view_case_to_paused(SceneManager.view_case) \
			or PuzzleOverview.view_case_to_paused(SceneManager.view_case)
	set_text(SceneManager.Cases.NONE if paused else SceneManager.view_case)
	visible = not paused
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Button_mouse_entered():
	modulate = Color(1.0, 1.0, 1.0, 0.8)


func _on_Button_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 0.5)


func _on_Button_pressed():
	SceneManager.info_visible = not SceneManager.info_visible

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
