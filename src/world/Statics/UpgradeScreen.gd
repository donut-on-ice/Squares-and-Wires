class_name UpgradeScreen extends StaticBody2D

#### VARS ####
# enums
# consts
const in_world_size := 16

const States := {
		IDLE			= "Idle",
		HOVERED			= "Hovered",
		IDLE_SHINING	= "Shining Idle",
		HOVERED_SHINING	= "Shining Hovered"
	}

# settings
# singletons
# nodes
onready var AT:AnimationTree = $AnimationTree
onready var state_machine:AnimationNodeStateMachinePlayback = AT.get("parameters/playback")
onready var ClickableArea:Area2D = $ClickArea

# public
var is_hovered := false setget set_hovered

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	if not ClickableArea.is_connected("mouse_entered", self, "_on_Clickable_Area_mouse_entered"):
		ClickableArea.connect("mouse_entered", self, "_on_Clickable_Area_mouse_entered")
	
	if not ClickableArea.is_connected("mouse_exited", self, "_on_Clickable_Area_mouse_exited"):
		ClickableArea.connect("mouse_exited", self, "_on_Clickable_Area_mouse_exited")
	
	AT.advance(0.0)
	state_machine.travel(get_target_state())
	
	add_to_group(Groups.SHINERS)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_hovered(h:bool):
	is_hovered = h
	update_animation()


### updates ###
func update_animation():
	state_machine.travel(get_target_state())


func activate():
	SceneManager.view_case = SceneManager.Cases.UPGRADE_TABLE

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
func get_target_state():
	return States.HOVERED if is_highlighted() else States.IDLE


### bools ###
func is_highlighted() -> bool:
	return is_hovered and Mouse.mouse_tool == Mouse.Tools.ARROW


### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func start_shining():
	state_machine.travel(States.HOVERED_SHINING if is_hovered else States.IDLE_SHINING)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Clickable_Area_mouse_entered():
	set_hovered(true)


func _on_Clickable_Area_mouse_exited():
	set_hovered(false)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
