tool
class_name ControlBoardIOs extends Node2D

#### VARS ####
# enums
# consts
# settings
export(int, 0, 4) var max_in:int setget set_max_in
export(int, 0, 4) var max_out:int setget set_max_out 

# singletons
# nodes
# public
var i0_val := 0 setget set_i0_val
var i1_val := 0 setget set_i1_val
var i2_val := 0 setget set_i2_val
var i3_val := 0 setget set_i3_val

var o0_val := 0 setget set_o0_val
var o1_val := 0 setget set_o1_val
var o2_val := 0 setget set_o2_val
var o3_val := 0 setget set_o3_val

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_max_in(i:int):
	
	max_in = i
	
	if is_inside_tree():
		get_node("i0").set_visible(0 < max_in)
		get_node("i1").set_visible(1 < max_in)
		get_node("i2").set_visible(2 < max_in)
		get_node("i3").set_visible(3 < max_in)


func set_max_out(o:int):
	
	max_out = o
	
	if is_inside_tree():
		get_node("o0").set_visible(0 < max_out)
		get_node("o1").set_visible(1 < max_out)
		get_node("o2").set_visible(2 < max_out)
		get_node("o3").set_visible(3 < max_out)


func set_ins_vals(ins:Array):
	
	if 0 < ins.size():
		set_i0_val(ins[0])
	if 1 < ins.size():
		set_i1_val(ins[1])
	if 2 < ins.size():
		set_i2_val(ins[2])
	if 3 < ins.size():
		set_i3_val(ins[3])
	

func set_i0_val(v:int):
	
	i0_val = v
	
	if is_inside_tree():
		get_node("i0").set_frame(v%4 + 0*4)


func set_i1_val(v:int):
	
	i1_val = v
	
	if is_inside_tree():
		get_node("i1").set_frame(v%4 + 1*4)


func set_i2_val(v:int):
	
	i2_val = v
	
	if is_inside_tree():
		get_node("i2").set_frame(v%4 + 2*4)


func set_i3_val(v:int):
	
	i3_val = v
	
	if is_inside_tree():
		get_node("i3").set_frame(v%4 + 3*4)


func set_ox_val(x:int, v:int):
	
	match x:
		0: set_o0_val(v)
		1: set_o1_val(v)
		2: set_o2_val(v)
		3: set_o3_val(v)


func set_o0_val(v:int):
	
	o0_val = v
	
	if is_inside_tree():
		get_node("o0").set_frame(v%4 + 4*4)


func set_o1_val(v:int):
	
	o1_val = v
	
	if is_inside_tree():
		get_node("o1").set_frame(v%4 + 5*4)


func set_o2_val(v:int):
	
	o2_val = v
	
	if is_inside_tree():
		get_node("o2").set_frame(v%4 + 6*4)


func set_o3_val(v:int):
	
	o3_val = v
	
	if is_inside_tree():
		get_node("o3").set_frame(v%4 + 7*4)
		
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
