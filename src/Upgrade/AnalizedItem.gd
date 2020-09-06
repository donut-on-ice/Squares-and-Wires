class_name AnalizedItem extends TextureRect

#### VARS ####
# enums
# consts
# settings
export(Upgrade.Types) var type:int = Upgrade.Types.NONE setget set_type

# singletons
# nodes
var ParentGUI = null

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	reset()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func reset():
	texture = null


func set_type(t:int):
	texture = Upgrade.IconTextures[t]
	
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
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
