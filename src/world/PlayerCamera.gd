class_name PlayerCamera extends Camera2D

#### VARS ####

# enums
# consts
const SHAKE_TIME := 0.2

# settings
# singletons
# nodes

# public
# private
var shake_time := 0.0
var shake_amount := 1.0

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)


func _physics_process(delta:float):
	
	if shake_time - delta <= 0.0:
		set_offset(Vector2.ZERO)
	
	shake_time = max(0.0, shake_time - delta)
	
	if shake_time > 0.0:
		set_offset(Vector2( \
			rand_range(-1.0, 1.0) * shake_amount, \
			rand_range(-1.0, 1.0) * shake_amount \
		))

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
func shake(damage:int):
	set_physics_process(true)
	shake_time = SHAKE_TIME
	shake_amount = 0.2 + 0.02 * min(damage, 5.0) 

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

## MasterNodeWatcherFuncs

func on_view_case_change():
	current = true if not Level.view_case_to_paused(SceneManager.view_case) else current
	pause_mode = Node.PAUSE_MODE_STOP \
			if current \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, current)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
