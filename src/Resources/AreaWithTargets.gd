class_name AreaWithTargets extends Area2D

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
var parent_is_targetable := false
var Targets := {}
var MainTargetArea

# private
# signals
signal target_entered
signal target_exited

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	if not is_connected("area_entered", self, "_on_HitArea_entered"):
		connect("area_entered", self, "_on_HitArea_entered")
	
	if not is_connected("area_exited", self, "_on_HitArea_exited"):
		connect("area_exited", self, "_on_HitArea_exited")

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
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_HitArea_entered(area:Area2D):
	
	if not "target" in area:
		return
	
	if not parent_is_targetable and area.target == get_parent():
		return
	
	if Targets.has(area.target):
		Targets[area.target].append(area)
	else:
		Targets[area.target] = [area]
		emit_signal("target_entered", area.target)


func _on_HitArea_exited(area:Area2D):
	
	if not "target" in area:
		return
		
	if not parent_is_targetable and area.target == get_parent():
		return
	
	if not Targets.has(area.target):
		return
	
	Targets[area.target].erase(area)
	
	if MainTargetArea == area:
		MainTargetArea = null
	
	if Targets[area.target].empty():
		Targets.erase(area.target)
		emit_signal("target_exited", area.target)
	

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
