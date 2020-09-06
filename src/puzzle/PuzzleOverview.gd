class_name PuzzleOverview extends Node2D


#### VARS ####

# settings
# constants
const States := {
		VISIBLE = "Visible",
		FADE_IN = "Fade In",
		FADE_OUT = "Fade Out",
		INVISIBLE = "Invisible"
	}

# singletons
# nodes
onready var Cam:Camera2D = $PuzzleCamera
var control_board setget set_control_board

# layers
# public
# private
var _old_pos:Point = Point.new(0, 0)

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	
	add_to_group(Groups.PUZZLE_OVERVIEW)
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)


func _unhandled_input (event:InputEvent) -> void:
	
	if control_board == null:
		return
	
	if event is InputEventMouseButton:
		
		var m_pos:Point = control_board.Layout.get_grid_mouse_position() 
		_old_pos = m_pos
		
		if Mouse.is_player_wiring(true):
			control_board.Layout.add_wire(_old_pos, m_pos)
		
		elif Mouse.is_player_dewiring(true):
			control_board.Layout.remove_wire(m_pos)
			
		elif Mouse.is_player_crowbarring():
			control_board.Layout.remove_component(control_board.Layout.get_grid_mouse_position())
		
		elif Mouse.is_player_placing_component():
			control_board.Layout.place_ghost_component()
		
	
	if event is InputEventMouseMotion:
		
		var m_pos:Point = control_board.Layout.get_grid_mouse_position()
		
		if Mouse.mouse_tool == Mouse.Tools.WIRE and !control_board.Layout.is_tile_wirable(m_pos.x, m_pos.y) \
				and Mouse.mouse_subtool == Mouse.SubTools.NONE:
			Mouse.set_mouse_subtool(Mouse.SubTools.NO_WIRE)
		
		if Mouse.mouse_tool == Mouse.Tools.WIRE and control_board.Layout.is_tile_wirable(m_pos.x, m_pos.y)\
				and Mouse.mouse_subtool == Mouse.SubTools.NO_WIRE:
			Mouse.set_mouse_subtool(Mouse.SubTools.NONE)
			
		if m_pos.x == _old_pos.x and m_pos.y == _old_pos.y:
			return
		
		if Mouse.is_player_wiring():
			control_board.Layout.add_wire(m_pos, _old_pos)
		elif Mouse.is_player_dewiring():
			control_board.Layout.remove_wire(m_pos)
			
		_old_pos = m_pos

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### sets ###
func set_visible(v:bool):
	
	if control_board != null:
		control_board.set_watching_io_states(v)
		
	.set_visible(v)


### utils ###
func set_control_board(cb) -> void:

	if control_board != null and control_board.Layout != null:
		remove_puzzle_layout()
	
	control_board = cb
	
	add_child(control_board.Layout)
	move_child(control_board.Layout, 0)
	
	control_board.IOStateHolder.set_active(true)
	control_board.set_watching_io_states(true)
	if not control_board.Layout.is_generated:
		control_board.Layout.generate_puzzle(cb.ios.max_in, cb.ios.max_out)


func remove_puzzle_layout() -> void:
	
	control_board.IOStateHolder.set_active(false)
	control_board.set_watching_io_states(false)
	
	remove_child(control_board.Layout)
	
	control_board = null

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.CONTROL_BOARD

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	
	var paused := view_case_to_paused(SceneManager.view_case)
	Cam.position = Cam.puzzle_center
	visible = not paused
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)
	
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--#




#### CLASSES ####
#--# CLASSES #--#
