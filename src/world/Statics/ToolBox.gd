class_name ToolBox extends StaticBody2D

#### VARS ####
# enums
enum Type {NO_TYPE, SIGMA_TYPE, PI_TYPE} 

# consts
const in_world_size := 12
const States := {
		IDLE_LOCKED				= "Idle Locked",
		HOVERED_LOCKED			= "Hovered Locked",
		IDLE_SHINING_LOCKED		= "Idle Shining Locked",
		HOVERED_SHINING_LOCKED	= "Hovered Shining Locked",
		IDLE_OPEN				= "Idle Open",
		OPENING					= "Opening",
		ERROR					= "Error"
	}

# settings
# required_input_as_int -> 2^16-1 (short) -> fiecre 1 biti inseamna combinatia aceasta este ceruta FORMAT SMALL
#   4 3 2 1 | x
#   ----------- 
#   0 0 0 0 - 0 
#   0 0 0 1 - 1 
#   0 0 1 0 - 2 
#   0 0 1 1 - 3 
#   0 1 0 0 - 4 
#   0 1 0 1 - 5 
#   0 1 1 0 - 6 
#   0 1 1 1 - 7
#   1 0 0 0 - 8 
#   1 0 0 1 - 9 
#   1 0 1 0 - A 
#   1 0 1 1 - B 
#   1 1 0 0 - C 
#   1 1 0 1 - D 
#   1 1 1 0 - E 
#   1 1 1 1 - F
export(int, FLAGS, "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F") var required_input_small:int
export(String) var hint_formula:String
export(Type) var required_formula_type:int = Type.SIGMA_TYPE

export(int) var not_nr:int = 0
export(int) var and_nr:int = 0
export(int) var or_nr:int = 0
export(int) var xor_nr:int = 0
export(int) var over_nr:int = 0
export(int) var under_nr:int = 0
export(Array, Resource) var upgrades := []


# singletons
# nodes
onready var AT:AnimationTree = $AnimationTree
onready var state_machine:AnimationNodeStateMachinePlayback = AT.get("parameters/playback")
onready var ClickableArea:Area2D = $ClickArea
 

# public
var is_solved = false setget set_solved
var is_open = false setget set_open
var is_hovered = false setget set_hovered

onready var component_counts := [not_nr, and_nr, or_nr, xor_nr, over_nr, under_nr] 

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():

	for up in upgrades:
		up.validate()
	
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
func set_solved(b:bool):

	is_solved = b
	
	update_animation()


func set_open(b:bool):
	
	is_open = b
	
	update_animation()


func set_hovered(b:bool):
	
	is_hovered = b and not (is_open or is_solved)
	
	update_animation()


func process_solution(solution_small:int):
	
	is_open = true
	is_solved = solution_small == required_input_small
	
	if is_solved:
		PlayerInventory.add_to_inventory(component_counts, upgrades)
	
	update_animation()


### updates ###
func update_animation():
	var state := get_target_state()
	is_open = false if state == States.ERROR else is_open
	state_machine.travel(state)
	
	# wired error with AT and state_machine. does not play ERROR when it should
	if state == States.ERROR:
		AT.advance(0.0)


func activate():
	
	if is_solved and is_open:
		return
	
	get_tree().call_group(Groups.LOCKPAD_STATE_HOLDERS,
			Groups.LockpadStateHolderFuncs.SET_CURRENT_TOOLBOX, self)
	
	SceneManager.view_case = SceneManager.Cases.LOCKPAD

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_target_state() -> String:
	return ((States.HOVERED_LOCKED if is_highlighted() else States.IDLE_LOCKED)\
				if not is_open \
				else States.ERROR) \
			if not is_solved \
			else States.IDLE_OPEN


func is_highlighted() -> bool:
	return is_hovered and Mouse.mouse_tool == Mouse.Tools.ARROW

### bools ###

### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	var ups_data := []
	
	for up in upgrades:
		ups_data.append(up.to_data())
	
	return {
		"is_solved":		is_solved,
		"is_open":			is_open,
		"component_counts": component_counts,
		"upgrades":			ups_data
	}


func from_data(data:Dictionary):
	
	if data.has("is_solved"): is_solved = data.is_solved
	if data.has("is_open"): is_open = data.is_open
	if data.has("component_counts"): component_counts = data.component_counts
	if data.has("upgrades"):
		upgrades.clear()
		for up_data in data.upgrades:
			var up := Upgrade.new()
			up.from_data(up_data)
			upgrades.append(up)
		
	var state := get_target_state()
	is_open = false if state == States.ERROR else is_open
	state_machine.start(state)
	AT.advance(0.0)


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####

func start_shining():
	match state_machine.get_current_node():
		States.IDLE_LOCKED:		state_machine.travel(States.IDLE_SHINING_LOCKED)
		States.HOVERED_LOCKED:	state_machine.travel(States.HOVERED_SHINING_LOCKED)


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
