class_name Heal extends Ability

#### VARS ####
# enums
# consts
# settings
export(int) var health:int = 0

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _init():
	type = Types.HEAL

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

func to_data() -> Dictionary:
	var data := .to_data()
	data.health = health
	return data


func form_data(data:Dictionary):
	.from_data(data)
	health = data.health if data.has("health") else 0

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
