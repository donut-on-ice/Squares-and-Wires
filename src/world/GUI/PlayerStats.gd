class_name PlayerStats extends HBoxContainer

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
onready var health_bar:HealthBarMiddle = $CenterContainer/Hp/Middle
var player:Player

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	on_mob_stats_change()

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

	if PlayerInventory.player != null:

		health_bar.max_health = PlayerInventory.player.stats.max_health
		health_bar.current_health = PlayerInventory.player.stats.health

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
