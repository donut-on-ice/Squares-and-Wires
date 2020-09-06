class_name Allies extends YSort

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	for c in get_children():
		if c.has_method("_on_parent_ready"):
			c._on_parent_ready()

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
	
	var data := {}
	
	for s in get_children():
		data[s.get_unique_name()] = s.to_data()
	
	return data


func from_data(data:Dictionary):
	
	for s in get_children():
		if data.has(s.get_unique_name()):
			s.from_data(data[s.get_unique_name()])
	

func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
