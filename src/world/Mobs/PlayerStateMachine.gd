class_name PlayerStateMachine
extends AnimationTree

#### VARS ####

# enums
enum Events{
		KILL_PLAYER, 
		MOVE_PLAYER, 
		STOP_PLAYER, 
		DAMAGE_PLAYER
	}

# consts
const States := {
		IDLE		= "Idle",
		WALK		= "Walk",
		DYING		= "Dying",
		DEAD		= "Dead"
	}

func do_nothing(): pass
func idle(): state_machine.travel(States.IDLE)
func walk(): state_machine.travel(States.WALK)
func die(): state_machine.travel(States.DYING)

onready var Funcs := {
	PASS = "do_nothing",
	IDLE = "idle",
	WALK = "walk",
	DIE_ = "die"
}

onready var TransitionMatrix := {
#	Events:				|KILL       |MOVE       |STOP       |DAMAGE
#						|PLYAER     |PLAYER     |PLAYER     |PLAYER

	States.IDLE:		[Funcs.DIE_, Funcs.WALK, Funcs.PASS, Funcs.PASS],
	States.WALK:		[Funcs.DIE_, Funcs.PASS, Funcs.IDLE, Funcs.PASS],
	States.DYING:		[Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.PASS],
	States.DEAD:		[Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.PASS]
}

# settings
# singletons
# nodes
onready var state_machine:AnimationNodeStateMachinePlayback = get("parameters/playback")
onready var root := get_parent()


# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	advance(0.0)
	state_machine.start(States.IDLE)


#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_all_blend_positions(p:Vector2) -> void:
	set("parameters/Idle/blend_position", p)
	set("parameters/Walk/blend_position", p)
	set("parameters/Dying/blend_position", p)
	set("parameters/Dead/blend_position", p)


### updates ###
func signal_event(event:int) -> void:
	if TransitionMatrix != null and TransitionMatrix.has(state_machine.get_current_node()):
		call(TransitionMatrix[state_machine.get_current_node()][event])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_current_state() -> String:
	return state_machine.get_current_node()

### bools ###
### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	return {
		"state": state_machine.get_current_node(),
		"orientation": get("parameters/Idle/blend_position")
	}


func from_data(data:Dictionary):
	
	if data.has("state"): state_machine.start(data.state)
	if data.has("orientation"): set_all_blend_positions(data.orientation)
	advance(0.0)

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
