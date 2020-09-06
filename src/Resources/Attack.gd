class_name Attack extends Ability

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
export(int) var penetration:int = 0
export(int) var damage:int = 0

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _init():
	type = Types.ATTACK

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
	data.damage = damage
	data.penetration = penetration
	return data


func form_data(data:Dictionary):
	.from_data(data)
	damage = data.damage if data.has("damage") else 0
	penetration = data.penetration if data.has("penetration") else 0
	
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
