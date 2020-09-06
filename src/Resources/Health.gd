class_name Health extends Upgrade

#### VARS ####
# enums
# consts
# settings
export(Array, int) var health_per_level := [0, 0, 0, 0, 0]

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func validate():
	type = Types.HEALTH
	for i in range(stats_array.size()):
		stats_array[i].max_health = health_per_level[i]
		stats_array[i].health = health_per_level[i]

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###

func bonus_to_str() -> String:
	return "Bonus HP: " + String(health_per_level[level])

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
