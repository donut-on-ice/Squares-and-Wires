class_name MapContext extends Node

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
var hovered_node:Node = null

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func get_focus(n:Node, 
		mouse_tool:int = Mouse.Tools.ARROW, 
		mouse_subtool:int = Mouse.SubTools.NONE):
	
	lose_focus()
	
	if n == null:
		return
	
	hovered_node = n
	
	if "hovered" in hovered_node:
		hovered_node.hovered = true

	Mouse.set_mouse_tool(mouse_tool)
	Mouse.set_mouse_tool(mouse_subtool)


func lose_focus():
	
	if hovered_node == null:
		return
	
	if "hovered" in hovered_node: 
		hovered_node.hovered = false
	
	hovered_node = null

	Mouse.set_mouse_tool(Mouse.Tools.ARROW)
	Mouse.set_mouse_tool(Mouse.SubTools.NONE)

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
