class_name MouseHolder extends Node


#### VARS ####
# enums
enum Tools {ARROW, WIRE, CROWBAR, CUTTERS, RADIO}
enum SubTools {ARROW, NO_WIRE, GRABBER, GRABBED, FANCY_ARROW, RADIO, NONE}

const tool_icons := {
		Tools.ARROW: preload("res://assets/mouse/c_arrow.png"),
		Tools.WIRE: preload("res://assets/mouse/c_wire.png"),
		Tools.CROWBAR: preload("res://assets/mouse/c_crowbar.png"),
		Tools.CUTTERS: preload("res://assets/mouse/c_cutters.png"),
		Tools.RADIO: preload("res://assets/mouse/c_radio_0.png")
	}
	
const subtools_animations := {
		SubTools.FANCY_ARROW: [preload("res://assets/mouse/c_arrow.png")],
		SubTools.NO_WIRE: [preload("res://assets/mouse/c_no_wire.png")],
		SubTools.GRABBER: [preload("res://assets/mouse/c_grabber_open.png")],
		SubTools.GRABBED: [	preload("res://assets/mouse/c_grabber_closed.png")],
		SubTools.FANCY_ARROW: [
			preload("res://assets/mouse/c_arrow_flashy_0.png"),
			preload("res://assets/mouse/c_arrow_flashy_1.png"),
			preload("res://assets/mouse/c_arrow_flashy_2.png"),
			preload("res://assets/mouse/c_arrow_flashy_3.png")],
		SubTools.RADIO: [
			preload("res://assets/mouse/c_radio_0.png"),
			preload("res://assets/mouse/c_radio_1.png"),
			preload("res://assets/mouse/c_radio_2.png")]
	}

const tool_icon_hot_spots:Array = [
		Vector2(2,4),
		Vector2(24,20),
		Vector2(3,5),
		Vector2(8,4),
		Vector2(5,5)
	]

const subtool_icon_hot_spots:Array = [
		Vector2(2,4),
		Vector2(24,20),
		Vector2(12,12),
		Vector2(12,12),
		Vector2(2,4),
		Vector2(5,5)
	]


# consts
# settings
# singletons
# nodes

# public
var mouse_tool:int = Tools.ARROW setget set_mouse_tool
var mouse_subtool:int = SubTools.NONE setget set_mouse_subtool
var selected_component:int = Component.Types.NONE setget set_selected_component
var playing_animation:bool = false setget set_playing_animation

# private
var frame_time := 0.15
var time := 0.0
var current_frame := 0

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	on_component_counts_change()
	add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)
			


func _physics_process(delta):

	if Level.view_case_to_paused(SceneManager.view_case):
		return
	
	if not playing_animation:
		return
	
	time += delta
	current_frame += int(floor(time/frame_time))
	current_frame %= subtools_animations[mouse_subtool].size()
	time = fmod(time, frame_time)
	
	Input.set_custom_mouse_cursor(
			subtools_animations[mouse_subtool][current_frame], 
			Input.CURSOR_ARROW, 
			subtool_icon_hot_spots[mouse_subtool])


func _input(event:InputEvent):
	
	if not Level.view_case_to_paused(SceneManager.view_case):
		map_input(event)
	
	if not PuzzleOverview.view_case_to_paused(SceneManager.view_case):
		control_board_input(event)


func map_input(_event:InputEvent):
	
	if Level.view_case_to_paused(SceneManager.view_case):
		return
	
	if Input.is_action_just_pressed("Radio"):
		set_mouse_tool(Tools.RADIO)
		set_mouse_subtool(SubTools.RADIO)
	elif Input.is_action_just_released("Radio"):
		set_mouse_tool(Tools.ARROW)
		set_mouse_subtool(SubTools.NONE)
	elif Input.is_action_pressed("Radio"):
		if Input.is_action_just_pressed("reset"):
			set_playing_animation(true)
		elif  Input.is_action_just_released("reset"):
			set_playing_animation(false)


func control_board_input(event:InputEvent):
	
	if not event is InputEventKey:
		return
	
	if PuzzleOverview.view_case_to_paused(SceneManager.view_case):
		return
	
	if Input.is_action_pressed("shift"):
		return
	
	if Input.is_action_just_pressed("select_arrow"):
		set_mouse_tool(Tools.ARROW)
	elif Input.is_action_just_pressed("select_wire"):
		set_mouse_tool(Tools.WIRE)
	elif Input.is_action_just_pressed("select_crowbar"):
		set_mouse_tool(Tools.CROWBAR)
	elif Input.is_action_just_pressed("select_cutters"):
		set_mouse_tool(Tools.CUTTERS)
	
	var set_to_component:int = Component.Types.NONE
	
	if Input.is_action_just_pressed("select_gate_not"):
		set_to_component = Component.Types.NOT 
	elif Input.is_action_just_pressed("select_gate_and"):
		set_to_component = Component.Types.AND 
	elif Input.is_action_just_pressed("select_gate_or"):
		set_to_component = Component.Types.OR 
	elif Input.is_action_just_pressed("select_gate_xor"):
		set_to_component = Component.Types.XOR 
	elif Input.is_action_just_pressed("select_bridge_over"):
		set_to_component = Component.Types.OVER 
	elif Input.is_action_just_pressed("select_bridge_under"):
		set_to_component = Component.Types.UNDER 
	
	if set_to_component != Component.Types.NONE:
		set_selected_component(set_to_component
				if selected_component != set_to_component
				else Component.Types.NONE)
	
	if Input.is_action_just_pressed("unselect_component"):
		set_selected_component(Component.Types.NONE)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_mouse_tool(i:int):
	mouse_tool = i
	mouse_subtool = SubTools.NONE
	set_playing_animation(false)
	update_mouse_icon()
	if selected_component != Component.Types.NONE \
			and mouse_tool != Tools.ARROW:
		set_selected_component(Component.Types.NONE)


func set_mouse_subtool(i:int):
	mouse_subtool = i
	set_playing_animation(false)
	update_mouse_icon()


func set_selected_component(i:int):
	selected_component = i
	update_selected_component()
	if mouse_tool != Tools.ARROW \
			and selected_component != Component.Types.NONE:
		set_mouse_tool(Tools.ARROW)


func set_playing_animation(b:bool):
	playing_animation = b
	current_frame = current_frame if playing_animation else 0
	time = time if playing_animation else 0.0
	update_mouse_icon()


# updates
func update_mouse_icon():
	if !is_inside_tree():
		return
		
	Input.set_custom_mouse_cursor(
			tool_icons[mouse_tool] \
					if mouse_subtool == SubTools.NONE \
					else subtools_animations[mouse_subtool][current_frame], 
			Input.CURSOR_ARROW, 
			tool_icon_hot_spots[mouse_tool] \
					if mouse_subtool == SubTools.NONE \
					else subtool_icon_hot_spots[mouse_subtool])
	
	get_tree().call_group(Groups.MOUSE_WATCHERS,
			Groups.MouseWatcherFuncs.ON_MOUSE_TOOL_CHANGE)


func update_selected_component():
	if !is_inside_tree():
		return
	get_tree().call_group(Groups.MOUSE_WATCHERS,
			Groups.MouseWatcherFuncs.ON_SELECTED_COMPONENT_CHANGE)
	

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###

### bools ###
func is_player_wiring(first_time:bool=false) -> bool:
	var set := Input.is_action_just_pressed("set") \
				if first_time \
				else Input.is_action_pressed("set")
	return mouse_tool == Tools.WIRE and set


func is_player_dewiring(first_time:bool=false) -> bool:
	var set := Input.is_action_just_pressed("set") \
				if first_time \
				else Input.is_action_pressed("set")
	var reset := Input.is_action_just_pressed("reset") \
				if first_time \
				else Input.is_action_pressed("reset")
	return mouse_tool == Tools.WIRE and reset \
			or mouse_tool == Tools.CUTTERS and (set or reset)


func is_player_crowbarring() -> bool:
	var set := Input.is_action_just_pressed("set")
	return mouse_tool == Tools.CROWBAR and set


func is_player_placing_component() -> bool:
	var set := Input.is_action_just_pressed("set")
	return selected_component != Component.Types.NONE and set

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

## PausableFuncs
func on_view_case_change():
	if PuzzleOverview.view_case_to_paused(SceneManager.view_case):
		set_mouse_tool(Tools.ARROW)
		set_selected_component(Component.Types.NONE)


## PlayerInventoryWatcherFuncs
func on_component_counts_change():
	
	if selected_component != Component.Types.NONE \
			and PlayerInventory.component_counts[selected_component] == 0:
		set_selected_component(Component.Types.NONE)


## MouseHolderFuncs
func on_mouse_holder_change():
	
	remove_from_group(Groups.MOUSE_TOOL_HOLDERS)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--#



#### CLASSES ####
#--# CLASSES #--#


