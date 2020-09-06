class_name ComponentPreview extends Node2D

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
onready var VisibleComponentBottom:TileMap = $VisibleComponentBottom
onready var VisibleComponentTop:TileMap = $VisibleComponentTop
onready var VisibleLights:TileMap = $VisibleLights
onready var PuzzleLayers = get_parent()

# public
var direction:int setget set_direction# PUtils.SimpleOrientation
var ghost:Component

# private
var _old_pos:Point
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	add_to_group(Groups.MOUSE_WATCHERS)
	on_selected_component_change()

func _input(event: InputEvent) -> void:
	
	if !is_visible_in_tree():
		return
	
	if event is InputEventMouseMotion:
		var m_pos:Point = PuzzleLayers.get_grid_mouse_position()
		if _old_pos == null or m_pos.x != _old_pos.x or m_pos.y != _old_pos.y:
			if Mouse.selected_component != Component.Types.NONE:
				redraw_ghost()
	
	if Input.is_action_just_pressed("rotate_selected_component"):
		match direction:
			PUtils.SimpleOrientation.E:
				set_direction(PUtils.SimpleOrientation.S)
			PUtils.SimpleOrientation.S:
				set_direction(PUtils.SimpleOrientation.W)
			PUtils.SimpleOrientation.W:
				set_direction(PUtils.SimpleOrientation.N)
			PUtils.SimpleOrientation.N:
				set_direction(PUtils.SimpleOrientation.E)
			_:
				set_direction(PUtils.SimpleOrientation.E)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_direction(d:int) -> void:
	
	if Mouse.selected_component == Component.Types.NONE:
		return
	
	direction = d
	redraw_ghost()
	

### updates ###
func redraw_ghost() -> void:
	
	if !is_inside_tree():
		return
		
	if Mouse.selected_component == Component.Types.NONE:
		clear_layers()
		return
	
	ghost = Component.new(
		PuzzleLayers.get_grid_mouse_position(),
		Mouse.selected_component, 
		direction)
		
	modulate = Color(1.0, 1.0, 1.0, 0.5) \
			if PuzzleLayers.is_component_placeable(ghost) \
			else Color(3.0, 0.75, 0.75, 0.375)
	
	clear_layers()
	draw_gate(ghost)
	_old_pos = ghost.pivot_position


func clear_layers() -> void:
	VisibleComponentBottom.clear()
	VisibleComponentTop.clear()
	VisibleLights.clear()


func draw_gate(g:Component) -> void:
	var true_pos := g.get_true_position()
	VisibleComponentTop.set_cell(true_pos.x, true_pos.y, g.get_component_tid(),
				false, false, false,
				g.get_component_atlas_position())
	VisibleComponentBottom.set_cell(true_pos.x, true_pos.y, g.get_component2_tid())
	
	for e in g.emitters:
		VisibleLights.set_cell(e.position.x, e.position.y, 
					e.get_light_tid(),
					false,false,false,
					e.get_light_atls_pos())
	
	for s in g.sinks:
		VisibleLights.set_cell(s.position.x, s.position.y, 
					s.get_light_tid(),
					false,false,false,
					s.get_light_atls_pos())

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_selected_component_change() -> void:
	
	visible = Mouse.selected_component != Component.Types.NONE
	
	redraw_ghost()


#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
