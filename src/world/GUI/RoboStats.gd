class_name RoboStats extends HBoxContainer

#### VARS ####
# enums
# consts
const States := {
		VISIBLE = "Visible",
		BLINK = "Blink",
		FADE_OUT = "Fade Out",
		INVISIBLE = "Invisible",
		FADE_IN = "FADE IN"
	}

# settings
export(bool) var moving:bool = false

# singletons
# nodes
onready var health_bar:HealthBarMiddle = $CenterContainer/Hp/Middle
onready var AT:AnimationTree = $AnimationTree
onready var state_machine:AnimationNodeStateMachinePlayback = AT.get("parameters/playback")

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	add_to_group(Groups.SAVABLES)
	on_mob_stats_change()
	on_can_radio_change()
	add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	AT.advance(0.0)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_mob_stats_change():

	if PlayerInventory.robo != null:

		health_bar.max_health = PlayerInventory.robo.stats.max_health
		health_bar.current_health = PlayerInventory.robo.stats.health


func on_can_radio_change():
	state_machine.travel(States.VISIBLE if PlayerInventory.can_radio else States.INVISIBLE)
	

func to_data() -> Dictionary:
	return {"state": state_machine.get_current_node()}


func from_data(data:Dictionary):
	if data.has("state"):
		state_machine.start(data.state)
	

func get_unique_name() -> String:
	return name

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
