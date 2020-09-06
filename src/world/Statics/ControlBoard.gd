class_name ControlBoard extends StaticBody2D


#### VARS ####
# enums
# consts
const in_world_size := 12
const States := {
		IDLE			= "Idle",
		HOVERED			= "Hovered",
		IDLE_SHINING	= "Idle Shining",
		HOVERED_SHINING	= "Hovered Shining"
	}

# settings
export(Array, NodePath) var output_paths

export(PackedScene) var PackedPuzzle:PackedScene

# singletons
# nodes
onready var AT:AnimationTree = $AnimationTree
onready var state_machine:AnimationNodeStateMachinePlayback = AT.get("parameters/playback")
onready var ios:ControlBoardIOs = $IOs
onready var IOStateWatcher:PuzzleIOStateWatcher = $PuzzleIOStateWatcher 
onready var IOStateHolder:PuzzleIOStateHolder = $PuzzleIOStateHolder
onready var ClickableArea:Area2D = $ClickArea

var Layout:PuzzleLayerHolder = null setget , get_layout

var outputs:Array

# public
var is_hovered := false setget set_hovered
var is_watching_io_states := false setget set_watching_io_states
var layout_data:Dictionary = {}

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

	on_mouse_tool_change()
	add_to_group(Groups.MOUSE_WATCHERS)


func _on_parrent_ready():
	
	outputs.clear()
	
	var ins := 0
	
	for path in output_paths:
		
		var output:ControlBoardOutput = get_node_or_null(path)
		ins = max(ins, output.input_bits)
		
		if output == null:
			continue
		
		outputs.append(output)
	
	
	if ios != null:
		ios.set_max_in(ins)
		ios.set_max_out(outputs.size())
		ios.set_ins_vals([
			PuzzleIOStateHolder.Values.TRUE,
			PuzzleIOStateHolder.Values.TRUE,
			PuzzleIOStateHolder.Values.TRUE,
			PuzzleIOStateHolder.Values.TRUE])
		
	update_state_holder()
	update_outputs()


func _notification(what):
	
	if what != NOTIFICATION_PREDELETE or Layout == null: 
		return 

	if Layout.get_parent() != null:
		Layout.get_parent().remove_child(Layout)

	Layout.queue_free()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_hovered(h:bool):
	
	is_hovered = h
	
	update_animation()


func set_watching_io_states(w:bool):
	is_watching_io_states = w
	IOStateWatcher.notify_parent = w


### updates ###
func get_target_state():
	return States.HOVERED if is_highlighted() else States.IDLE


func update_animation():
	state_machine.travel(get_target_state())
	

func update_state_holder():
	
	var update := []
	
	for o in outputs:
		update.append(PUtils.bool_1bit_to_2bit(o.required_output_small))
	
	if update.size() <  IOStateHolder.required_output_states.size():
		for _i in range(update.size(), IOStateHolder.required_output_states.size()):
			update.append(0)
	else: 
		update.resize(IOStateHolder.required_output_states.size())
	
	IOStateHolder.set_required_output_states(update)
 

func update_outputs():
	
	var matches := IOStateHolder.are_outputs_matcing(outputs.size())
	
	for o in range(outputs.size()):
		outputs[o].control_board_to_input[name] = matches[o]
		outputs[o].update_input_provided()
		ios.set_ox_val(o, PuzzleIOStateHolder.Values.TRUE if matches[o] else PuzzleIOStateHolder.Values.FALSE)


func activate():
	
	get_tree().call_group(Groups.PUZZLE_OVERVIEW,
			Groups.PuzzleOverviewFuncs.SET_CONTROL_BOARD, self)
	
	SceneManager.view_case = SceneManager.Cases.CONTROL_BOARD


#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_layout() -> PuzzleLayerHolder:
	
	if Layout == null:
		Layout = PackedPuzzle.instance() \
				if PackedPuzzle != null \
				else preload("res://Scenes/PuzzleLayouts/NoLayout.tscn").instance()
		Layout.ready_data = layout_data
	
	return Layout


func is_highlighted() -> bool:
	return is_hovered and Mouse.mouse_tool == Mouse.Tools.ARROW

### bools ###
### utils ###

#--# NON STATE CHANGING METHODS #--#


#### DATA METHODS ####

func to_data() -> Dictionary:
	
	return {
			"IOStateHolderData":				IOStateHolder.to_data(),
			"LayoutData":						Layout.to_data() if Layout != null else {},
			"is_watching_io_states":			is_watching_io_states
		}


func from_data(data:Dictionary):
	
	if Layout != null:
		var layout_parrent:Node = Layout.get_parent()
		
		if layout_parrent != null:
			layout_parrent.remove_child(Layout)
		
		Layout.queue_free()
	
	if data.has("LayoutData"):
		layout_data = data.LayoutData
		
	if data.has("IOStateHolderData"): IOStateHolder.from_data(data.IOStateHolderData)
	if data.has("is_watching_io_states"): is_watching_io_states = data.is_watching_io_states
	
	state_machine.start(get_target_state())
	AT.advance(0.0)


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#


#### GROUP METHODS ####

func start_shining():
	state_machine.travel(States.HOVERED_SHINING if is_hovered else States.IDLE_SHINING)


func on_output_states_change() -> void:
	
	if IOStateWatcher.StateHolder == null:
		return
	
	update_outputs()


func on_required_output_states_change() -> void:
	if IOStateWatcher.StateHolder == null:
		return
	
	update_outputs()


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
