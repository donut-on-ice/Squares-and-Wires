class_name RoboStateMachine extends AnimationTree

#### VARS ####

# enums
enum Events {
		KILL_ROBO,
		MOVE_ROBO,
		STOP_ROBO,
		DAMAGE_ROBO,
		REVIVE_ROBO,
		ROBO_SMASH
	}

# consts
const States := {
		IDLE			= "Idle",
		WALK			= "Walk", 
		SMASH			= "Smash",
		ACTIVATING		= "Activating",
		DEACTIVATING	= "Deactivating",
		SLEEPING		= "Sleeping"
	}

func do_nothing(): pass
func idle(): state_machine.travel(States.IDLE)
func walk(): state_machine.travel(States.WALK)
func die(): state_machine.travel(States.SLEEPING)
func smash(): state_machine.travel(States.SMASH)

onready var Funcs := {
	PASS = "do_nothing",
	IDLE = "idle",
	WALK = "walk",
	DIE_ = "die",
	ATK_ = "smash"
}

onready var TransitionMatrix := {
#	Events:				|KILL       |MOVE       |STOP       |DAMAGE     |REVIVE     |ROBO
#						|ROBO       |ROBO       |ROBO       |ROBO       |ROBO       |SMASH

	States.IDLE:		[Funcs.DIE_, Funcs.WALK, Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.ATK_],
	States.WALK:		[Funcs.DIE_, Funcs.PASS, Funcs.IDLE, Funcs.PASS, Funcs.PASS, Funcs.ATK_],
	States.SMASH:		[Funcs.DIE_, Funcs.WALK, Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.PASS],
	States.ACTIVATING:	[Funcs.DIE_, Funcs.WALK, Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.ATK_],
	States.DEACTIVATING:[Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.IDLE, Funcs.PASS],
	States.SLEEPING:	[Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.PASS, Funcs.IDLE, Funcs.PASS]
}

# settings
# singletons
# nodes
onready var state_machine:AnimationNodeStateMachinePlayback = get("parameters/playback")

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
	set("parameters/Activating/blend_position", p)
	set("parameters/Deactivating/blend_position", p)
	set("parameters/Idle/blend_position", p)
	set("parameters/Sleeping/blend_position", p)
	set("parameters/Smash/blend_position", p)
	set("parameters/Walk/blend_position", p)

### updates ###
func signal_event(event:int) -> void:
	if TransitionMatrix != null and TransitionMatrix.has(state_machine.get_current_node()):
		call(TransitionMatrix[state_machine.get_current_node()][event])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
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
