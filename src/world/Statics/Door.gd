tool
class_name Door extends ControlBoardOutput


#### VARS ####
# enums
# consts
const in_world_size := 4
const States := {
		IDLE_LOCKED					= "Idle Locked",
		IDLE_SHINING_LOCKED			= "Idle Shining Locked",
		IDLE_UNLOCKED				= "Idle Unlocked",
		IDLE_SHINING_UNLOCKED		= "Idle Shining Unlocked",
		IDLE_OPEN					= "Idle Open",
		HOVERED_LOCKED				= "Hovered Locked",
		HOVERED_SHINING_LOCKED		= "Hovered Shining Locked",
		HOVERED_UNLOCKED			= "Hovered Unlocked",
		HOVERED_SHINING_UNLOCKED	= "Hovered Shining Unlocked",
		HOVERED_OPEN				= "Hovered Open",
		OPENING						= "Opening",
		CLOSING						= "Closing",
		ERROR						= "Error"
	}

# settings
export(bool) var is_open := false setget set_open
export(bool) var is_ns := false

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
	
	if Engine.editor_hint:
		return
	
	if not ClickableArea.is_connected("mouse_entered", self, "_on_Clickable_Area_mouse_entered"):
		ClickableArea.connect("mouse_entered", self, "_on_Clickable_Area_mouse_entered")
	
	if not ClickableArea.is_connected("mouse_exited", self, "_on_Clickable_Area_mouse_exited"):
		ClickableArea.connect("mouse_exited", self, "_on_Clickable_Area_mouse_exited")
		
	AT.advance(0.0)
	var state := get_target_state()
	is_open = false if state == States.ERROR else is_open
	state_machine.start(state)
	
	add_to_group(Groups.SHINERS)
	
	on_mouse_tool_change()
	add_to_group(Groups.MOUSE_WATCHERS)
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_open(o:bool) -> void:
	is_open = o
	update_animation()


func set_hovered(h:bool) -> void:
	is_hovered = h
	update_animation()


func set_input_provided(ip:bool) -> void:
	.set_input_provided(ip)
	set_open(is_open)

### updates ###
func update_animation() -> void:
	
	if Engine.editor_hint:
		return
	
	if state_machine == null:
		return
	
	var state := get_target_state()
	is_open = false if state == States.ERROR else is_open
	state_machine.travel(state)


func activate():
	set_open(!is_open)
	if PlayerInventory.player != null:
		PlayerInventory.player.unfog()

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_target_state() -> String:
	var is_highlighted = is_highlighted()
	return ((States.HOVERED_UNLOCKED if is_highlighted else States.IDLE_UNLOCKED) \
				if not is_open \
				else (States.HOVERED_OPEN if is_highlighted else States.IDLE_OPEN)) \
			if is_input_provided() \
			else ((States.HOVERED_LOCKED if is_highlighted else States.IDLE_LOCKED) \
				if not is_open \
				else States.ERROR)


func is_highlighted() -> bool:
	
	if Engine.editor_hint:
		return false
	
	return is_hovered and Mouse.mouse_tool == Mouse.Tools.ARROW


func get_target_global_position() -> Vector2:
	return global_position + Vector2(0, 25 if is_ns else 5)

### bools ###
### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	var data := .to_data()
	
	data.is_open = is_open
	
	return data


func from_data(data:Dictionary):
	
	.from_data(data)
	
	if data.has("is_open"): is_open = data.is_open
	
	var state := get_target_state()
	is_open = false if state == States.ERROR else is_open
	state_machine.start(state)
	AT.advance(0.0)


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####

func start_shining():
	
	if Engine.editor_hint:
		return
	
	match state_machine.get_current_node():
		States.IDLE_LOCKED:			state_machine.travel(States.IDLE_SHINING_LOCKED)
		States.IDLE_UNLOCKED:		state_machine.travel(States.IDLE_SHINING_UNLOCKED)
		States.HOVERED_LOCKED:		state_machine.travel(States.HOVERED_SHINING_LOCKED)
		States.HOVERED_UNLOCKED:	state_machine.travel(States.HOVERED_SHINING_UNLOCKED)


func on_mouse_tool_change():
	update_animation()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Clickable_Area_mouse_entered():
	set_hovered(true)


func _on_Clickable_Area_mouse_exited():
	set_hovered(false)

#--# SIGNAL METHODS #--# 


#### CLASSES ####
#--# CLASSES #--#
