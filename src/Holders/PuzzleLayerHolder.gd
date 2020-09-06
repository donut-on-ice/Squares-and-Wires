class_name PuzzleLayerHolder extends Node2D

#### VARS ####

# enums
enum Dificulty {EASY, NORMAL, HARD, CUSTOM}

# consts
const TILE_SET:TileSet = preload("res://assets/tilesets/PuzzleTileset.tres")
onready var Tiles := {
		EMPTY =				TileMap.INVALID_CELL,
	
		# technical layer
		TECHNICAL = 		TILE_SET.find_tile_by_name("technical"),
		
		# grounds layer
		GROUND =			TILE_SET.find_tile_by_name("ground"),
		
		# wires layer
		WIRE =				TILE_SET.find_tile_by_name("wire"),
		
		# walls layer
		WALL =				TILE_SET.find_tile_by_name("wall"),
		WALL_IN_OUT =		TILE_SET.find_tile_by_name("w. io"),
		
		G_2X1_EW =			TILE_SET.find_tile_by_name("g. 2x1 EW"),
		G_1X2_NS =			TILE_SET.find_tile_by_name("g. 1x2 NS"),
		G_2X2_EW =			TILE_SET.find_tile_by_name("g. 2x2 EW"),
		G_2X2_S =			TILE_SET.find_tile_by_name("g. 2x2 S"),
		G_2X2_N =			TILE_SET.find_tile_by_name("g. 2x2 N"),
		
		# gates layer
		G_NOT_EW =			TILE_SET.find_tile_by_name("g. not EW"),
		G_NOT_NS =			TILE_SET.find_tile_by_name("g. not NS"),
		G_AND =				TILE_SET.find_tile_by_name("g. and"),
		G_OR =				TILE_SET.find_tile_by_name("g. or"),
		G_XOR =				TILE_SET.find_tile_by_name("g. xor"),
		
		G_2X1_ERROR =		TILE_SET.find_tile_by_name("g. 2x1 error"),
		G_1X2_ERROR =		TILE_SET.find_tile_by_name("g. 1x2 error"),
		G_2X2_ERROR =		TILE_SET.find_tile_by_name("g. 2x2 error"),
		
		# lights Layer
		LIGHT_WALL_IN =		TILE_SET.find_tile_by_name("light wall in"),
		LIGHT_WALL_OUT = 	TILE_SET.find_tile_by_name("light wall out"),
		LIGHT_GATE_IN =		TILE_SET.find_tile_by_name("light gate in"),
		LIGHT_GATE_OUT =	TILE_SET.find_tile_by_name("light gate out"),
		
		# labels layer
		LABEL =				TILE_SET.find_tile_by_name("label"),
		
		# bridges layer
		W_BRIDGE_NS =		TILE_SET.find_tile_by_name("bridge NS"),
		W_BRIDGE_EW =		TILE_SET.find_tile_by_name("bridge EW"),
		
		# jacks layer
		JACK =				TILE_SET.find_tile_by_name("jack")
	}

# settings 
export(Dificulty) var dificulty:int = Dificulty.EASY
export(int, 0, 4) var max_ins:int = 4
export(int, 0, 4) var max_outs:int = 4

# singletons
# nodes
onready var Technical:TileMap = $Technical
onready var Ground:TileMap = $Ground
onready var Wires:PuzzleTileMap = $Wires
onready var Walls:TileMap = $Walls
onready var Gates:TileMap = $Gates
onready var Lights:TileMap = $Lights
onready var Labels:TileMap = $Labels
onready var Bridges:TileMap = $Bridges
onready var Jacks:TileMap = $Jacks
onready var Props:TileMap = $Props
onready var DebugTiles:TileMap = $Debug

onready var CameraObserver = $CameraObserver
onready var IOStateObserver = $IOStateObserver
onready var GhostComponent:ComponentPreview = $GhostComponent

# public
var limits:Point = Point.new(0, 0) setget set_limits
var puzzle_ins:Array = []
var puzzle_outs:Array = []
var components:Array = []
var bridges:Array = []


# private
var _connection_holder:ConnectionHolder
var is_generated := false
var ready_data:Dictionary
var debug:bool = false
var index:int = 0

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	CameraObserver.notify_parent = true
	IOStateObserver.notify_parent = true
	
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME,
			Groups.PUZZLE_LAYER_HOLDERS,
			Groups.PuzzleLayerHolderFuncs.ON_PUZZLE_LAYER_HOLDER_CHANGE)
	add_to_group(Groups.PUZZLE_LAYER_HOLDERS)
	get_tree().call_group(Groups.PUZZLE_LAYER_WATCHERS,
			Groups.PuzzleLayerWatcherFuncs.ON_PUZZLE_LAYER_HOLDER_CHANGE,
			self)


func _input(event:InputEvent):
	
	if not event is InputEventKey:
		return
		
	if SceneManager.view_case != SceneManager.Cases.CONTROL_BOARD:
		return
	
	var start = false
	if event.scancode == KEY_Z and not event.is_echo() and event.is_pressed():
		debug = not debug
		start = debug
		DebugTiles.visible = debug
		index = 0
	
	if not debug:
		return
	
	if _connection_holder.connections.size() <= 0:
		return
	
	var next = event.scancode == KEY_UP and not event.is_echo() and event.is_pressed()
	var prev = event.scancode == KEY_DOWN and not event.is_echo() and event.is_pressed()
	
	index += int(next) - int(prev)
	index = max(0, min(index, _connection_holder.connections.size() - 1))
	
	if next or prev or start:
		show_debug(index)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters
## map
func set_limits(l:Point):
	limits.x = l.x 
	limits.y = l.y
	if CameraObserver != null and CameraObserver.ObservedCamera != null:
		CameraObserver.ObservedCamera.reset_cam_limits(limits)


## tiles
func add_ground_tile(p:Point):
	Ground.set_cell(p.x, p.y, Tiles.GROUND)


func add_wall_tile(p:Point):
	Walls.set_cell(p.x, p.y-1, Tiles.WALL)


func add_technical_tiles(origin:Point, atls:Array):
	for atl_pos in atls:
		Technical.set_cell(origin.x + int(atl_pos.x), origin.y + int(atl_pos.y),
				Tiles.TECHNICAL,
				false, false, false,
				atl_pos)


func add_wire(m_pos:Point, old_pos:Point):
	if !is_tile_in_limits(m_pos.x, m_pos.y):
		return
	if !is_tile_wirable(m_pos.x, m_pos.y):
		return
	
	if !is_tile_wire(m_pos.x, m_pos.y):
		add_wire_dot(m_pos)
#		if is_undoable:
#			[].append(ret)
	
	if is_pair_connectable(m_pos, old_pos):
		connect_wire_tile_with_given_neighbours(m_pos, [old_pos])
#		if is_undoable:
#			[].append(ret)
	
	regenerate_connection_matrix()


func remove_wire(pos:Point):
	if !is_tile_in_limits(pos.x, pos.y):
		return
	if !is_tile_wire(pos.x, pos.y):
		return

	var neighbour_pos:Point
	var neighbours := []
		
	neighbour_pos = Point.new(pos.x-1, pos.y)
	if is_tile_wire(neighbour_pos.x, neighbour_pos.y):
		neighbours.append(neighbour_pos)
		
	neighbour_pos = Point.new(pos.x+1, pos.y)
	if is_tile_wire(neighbour_pos.x, neighbour_pos.y):
		neighbours.append(neighbour_pos)
		
	neighbour_pos = Point.new(pos.x, pos.y-1)
	if is_tile_wire(neighbour_pos.x, neighbour_pos.y):
		neighbours.append(neighbour_pos)
		
	neighbour_pos = Point.new(pos.x, pos.y+1)
	if is_tile_wire(neighbour_pos.x, neighbour_pos.y):
		neighbours.append(neighbour_pos)
	
	_connection_holder.remove_connection_by_bit(pos)
	disconnect_wire_tile_from_given_neighbours(pos, neighbours)
#	if is_undoable:
#		[].append(ret)
	remove_wire_dot(pos)
#	if is_undoable:
#		[].append(ret)
	regenerate_connection_matrix()


func add_light_tile(l:IOLight):
	Lights.set_cell(
			l.position.x, l.position.y, 
			l.get_light_tid(), 
			false, false, false, 
			l.get_light_atls_pos())
	
	var n_pos:Point
	var l_so:int = l.simple_direction
	var l_pos:Point = l.position
	
	if is_tile_jack(l_pos.x, l_pos.y):
		remove_jack_tile(l_pos)
	
	
	if !is_tile_wire(l_pos.x, l_pos.y):
		return
	
	var neighbours := []
	
	n_pos = PUtils.get_neighbour_pos(l_pos, PUtils.SimpleOrientation.E)
	if is_tile_wire(n_pos.x, n_pos.y) and l_so != PUtils.SimpleOrientation.E:
		neighbours.append(n_pos)
		
	n_pos = PUtils.get_neighbour_pos(l_pos, PUtils.SimpleOrientation.W)
	if is_tile_wire(n_pos.x, n_pos.y) and l_so != PUtils.SimpleOrientation.W:
		neighbours.append(n_pos)
	
	n_pos = PUtils.get_neighbour_pos(l_pos, PUtils.SimpleOrientation.S)
	if is_tile_wire(n_pos.x, n_pos.y) and l_so != PUtils.SimpleOrientation.S:
		neighbours.append(n_pos)
		
	n_pos = PUtils.get_neighbour_pos(l_pos, PUtils.SimpleOrientation.N)
	if is_tile_wire(n_pos.x, n_pos.y) and l_so != PUtils.SimpleOrientation.N:
		neighbours.append(n_pos)
	
	disconnect_wire_tile_from_given_neighbours(l_pos, neighbours)
	n_pos = PUtils.get_neighbour_pos(l_pos, l_so)
	
	if is_a_plugable_in_b(n_pos, l_pos):
		add_plug_a_in_b(n_pos, l_pos)
	# add to action stack
	
	_connection_holder.remove_connection_by_bit(l_pos)
	regenerate_connection_matrix()


func remove_light_tile(l:IOLight):
	Lights.set_cell(l.position.x, l.position.y, Tiles.EMPTY)
	
	var n_pos:Point
	var l_so:int = l.simple_direction
	var l_pos:Point = l.position
		
	if !is_tile_wire(l_pos.x, l_pos.y):
		return

	n_pos = PUtils.get_neighbour_pos(l_pos, l_so)
	if is_tile_wire(n_pos.x, n_pos.y):
		remove_plug_from_a_in_b(n_pos, l_pos)
		if is_a_plugable_in_b(l_pos, n_pos):
			add_plug_a_in_b(l_pos, n_pos)
	
	_connection_holder.remove_connection_by_bit(l_pos)
	regenerate_connection_matrix()


func remove_jack_tile(l_pos:Point):
	Jacks.set_cell(l_pos.x, l_pos.y - 1, Tiles.EMPTY)


## gates/bridges multi-tiles
func add_component(c:Component, decrement:bool = true):
	
	if c.is_bridge():
		add_bridge(c, decrement)
	elif c.is_gate():
		add_gate(c, decrement)


func add_gate(g:Component, decrement:bool = true):
	
	if g == null \
			or !is_component_placeable(g) \
			or !g.is_gate() \
			or (decrement and !PlayerInventory.can_decrement_compoennt_count(g.type)):
		return
	
	if decrement:
		PlayerInventory.decrement_compoenent_count(g.type)
	
	var p := g.get_true_position()
	
	Gates.set_cell(p.x, p.y, g.get_component_tid())
	Walls.set_cell(p.x, p.y, g.get_component2_tid(),
			false, false, false,
			g.get_component_atlas_position())
	
	var atls := g.get_technical_atls()
	add_technical_tiles(g.get_true_position(), atls)
	
	var empty_pos := g.get_empty_spot()
	
	if empty_pos != null:
		remove_wire(empty_pos)
	
	components.append(g)
	
	for e in g.emitters:
		add_light_tile(e)
	
	for s in g.sinks:
		add_light_tile(s)


func add_bridge(b:Component, decrement:bool = true):
	
	if b == null \
			or !is_component_placeable(b) \
			or !b.is_bridge() \
			or (decrement and !PlayerInventory.can_decrement_compoennt_count(b.type)):
		return
	
	if decrement:
		PlayerInventory.decrement_compoenent_count(b.type)
	
	var p := b.get_true_position()
	
	Bridges.set_cell(p.x, p.y, b.get_component_tid(),
			false, false, false,
			b.get_component_atlas_position())
	
	var atls := b.get_technical_atls()
	add_technical_tiles(b.get_true_position(), atls)
	
	bridges.append(b)
	
	if b.direction == PUtils.SimpleOrientation.E \
			or b.direction == PUtils.SimpleOrientation.W:
		var np = Point.new(p.x + 2, p.y)
		flatten_connections(p, np)
		regenerate_connection_matrix()
	elif b.direction == PUtils.SimpleOrientation.S \
			or b.direction == PUtils.SimpleOrientation.N:
		var np = Point.new(p.x, p.y + 2)
		flatten_connections(p, np)
		regenerate_connection_matrix()


func remove_component(pos:Point):
	
	if is_tile_bridge(pos.x, pos.y):
		remove_bridge(get_bridge_from_tile(pos))
	elif is_tile_gate(pos.x, pos.y):
		remove_gate(get_gate_from_tile(pos))


func get_gate_from_tile(pos:Point) -> Component:
	
	if !is_tile_gate(pos.x, pos.y):
		return null
		
	var true_pos := get_true_position_from_technical_tile(pos)
	for g in components:
		var g_true_pos := (g as Component).get_true_position()
		if g_true_pos.x == true_pos.x and g_true_pos.y == true_pos.y:
			return g
	
	return null


func remove_gate(g:Component):
	
	if g == null \
			or !g.is_gate() \
			or !PlayerInventory.can_increment_compoennt_count(g.type):
		return
	
	PlayerInventory.increment_compoennt_count(g.type)
	
	components.erase(g)
	
	var true_pos := g.get_true_position()
	
	Gates.set_cell(true_pos.x, true_pos.y, Tiles.EMPTY)
	Walls.set_cell(true_pos.x, true_pos.y, Tiles.EMPTY)
	
	for t in g.get_technical_atls():
		Technical.set_cell(
				true_pos.x + int(t.x), 
				true_pos.y + int(t.y), 
				Tiles.EMPTY)
	
	for s in g.sinks:
		remove_light_tile(s)
		
	for e in g.emitters:
		remove_light_tile(e) 


func get_bridge_from_tile(pos:Point) -> Component:
	
	if !is_tile_bridge(pos.x, pos.y):
		return null
		
	var true_pos := get_true_position_from_technical_tile(pos)
	
	for b in bridges:
		var b_true_pos := (b as Component).get_true_position()
		
		if b_true_pos.x == true_pos.x and b_true_pos.y == true_pos.y:
			return b
	
	return null


func remove_bridge(b:Component):
	
	if b == null \
			or !b.is_bridge() \
			or !PlayerInventory.can_increment_compoennt_count(b.type):
		return
	
	PlayerInventory.increment_compoennt_count(b.type)
	
	bridges.erase(b)
	
	var true_pos := b.get_true_position()
	
	Bridges.set_cell(true_pos.x, true_pos.y, Tiles.EMPTY)
	
	for t in b.get_technical_atls():
		Technical.set_cell(
				true_pos.x + int(t.x), 
				true_pos.y + int(t.y), 
				Tiles.EMPTY)
	
	var p := b.get_true_position()
	var np:Point
	
	if b.direction == PUtils.SimpleOrientation.E \
			or b.direction == PUtils.SimpleOrientation.W:
		np = Point.new(p.x + 2, p.y)
	elif b.direction == PUtils.SimpleOrientation.S \
			or b.direction == PUtils.SimpleOrientation.N:
		np = Point.new(p.x, p.y + 2)
	
	if is_tile_wire(p.x, p.y) and is_tile_wire(np.x, np.y):
		_connection_holder.remove_connection_by_bit(p)
		regenerate_connection_matrix()


func generate_io_from_tile(pos:Point) -> Component:
	
	var true_pos := Point.new(pos.x, pos.y - 1)
	
	var type := Lights.get_cell(pos.x, pos.y)
	var i := int(Labels.get_cell_autotile_coord(pos.x, pos.y).x)
	var dir := int(Walls.get_cell_autotile_coord(true_pos.x, true_pos.y).x)

	if type == Tiles.LIGHT_WALL_IN:
		type = Component.Types.WALL_IN
	elif type == Tiles.LIGHT_WALL_OUT:
		type = Component.Types.WALL_OUT
	else:
		return null
	
	return Component.new(pos, type, dir, i)


func add_io(io:Component):
	
	if !io.is_wall_io():
		return
		
	var p := io.get_true_position()
	Walls.set_cell(p.x, p.y, io.get_component_tid(),
			false, false, false,
			io.get_component_atlas_position())
	
	Labels.set_cell(io.pivot_position.x, io.pivot_position.y, Tiles.LABEL,
			false, false, false,
			Vector2(io.index, 0))
	
	if io.type == Component.Types.WALL_IN:
		puzzle_ins[io.index] = io
	elif io.type == Component.Types.WALL_OUT:
		puzzle_outs[io.index] = io
		
	for s in io.sinks:
		add_light_tile(s)
	
	for e in io.emitters:
		add_light_tile(e)


func remove_io(io:Component):
	
	if io == null or !io.is_wall_io():
		return
	
	var label_pos := io.pivot_position
	var true_pos := io.get_true_position()
	
	Labels.set_cell(label_pos.x, label_pos.y, TileMap.INVALID_CELL)
	
	Walls.set_cell(true_pos.x, true_pos.y, Tiles.WALL)
	
	for s in io.sinks:
		remove_light_tile(s)
		
	for e in io.emitters:
		remove_light_tile(e) 


## wire helpers
func add_wire_dot(t:Point):
	Wires.set_cell(t.x, t.y,
			Tiles.WIRE,
			false, false, false,
			PUtils.MO_ATL_POS[PUtils.MultiOrientation.NONE])


func remove_wire_dot(t:Point):
	Wires.set_cell(t.x, t.y, Tiles.EMPTY)
	remove_jack_tile(t)
#	return{"action":"remove_wire_dot"; "arguments":[t]}
	pass


func connect_wire_tile_with_given_neighbours(w:Point, neighbours:Array):
	
	for n in neighbours:
		connect_wires(w, n)
		flatten_connections(w, n)
	
#	return {"action":"connect_wire_tile_with_given_neighbours"; "arguments":[w, neighbouts]}
	pass


func disconnect_wire_tile_from_given_neighbours(w:Point, neighbours:Array):
	
	_connection_holder.remove_connection_by_bit(w)
	
	for n in neighbours:
		disconnect_wires(w, n)
		
	# regenerate_connection_matrix()
	
#	return {"action":"disconnect_wire_tile_from_given_neighbours; "arguments":[w, neighbouts]}
	pass


func connect_wires(t0:Point, t1:Point):
	if !is_pair_connectable(t0, t1):
		return
	
	add_wire_connection_a_from_b(t0, t1)
	add_wire_connection_a_from_b(t1, t0)


func disconnect_wires(t0:Point, t1:Point):
	remove_wire_connection_a_from_b(t0, t1)
	remove_wire_connection_a_from_b(t1, t0)


func add_wire_connection_a_from_b(a:Point, b:Point):
	var mo_dir := PUtils.get_a_towards_b_dir_mo(a, b) \
			| PUtils.get_tile_direction(Wires, a.x, a.y)
	var atl_pos:Vector2 = PUtils.MO_ATL_POS[mo_dir]
	Wires.set_cell(a.x, a.y,
			Tiles.WIRE,
			false, false, false,
			atl_pos)
		
	if is_a_plugable_in_b(a, b):
		add_plug_a_in_b(a, b)


func remove_wire_connection_a_from_b(a:Point, b:Point):
	var mo_dir := ~PUtils.get_a_towards_b_dir_mo(a, b) \
			& PUtils.get_tile_direction(Wires, a.x, a.y)
	var atl_pos:Vector2 = PUtils.MO_ATL_POS[mo_dir]
	Wires.set_cell(a.x, a.y,
			Tiles.WIRE,
			false, false, false,
			atl_pos)
	
	remove_plug_from_a_in_b(a, b)


func add_plug_a_in_b(a:Point, b:Point):
	var mo_dir := PUtils.get_a_towards_b_dir_mo(a, b) \
			| PUtils.get_tile_direction(Jacks, a.x, a.y - 1)
	var atl_pos = PUtils.MO_ATL_POS[mo_dir]
	Jacks.set_cell(a.x, a.y - 1,
			Tiles.JACK,
			false, false, false,
			atl_pos)


func remove_plug_from_a_in_b(a:Point, b:Point):
	var mo_dir := ~PUtils.get_a_towards_b_dir_mo(a, b) \
			& PUtils.get_tile_direction(Jacks, a.x, a.y - 1)
	var atl_pos:Vector2 = PUtils.MO_ATL_POS[mo_dir]
	if atl_pos == Vector2.ZERO:
			Jacks.set_cell(a.x, a.y-1, Tiles.EMPTY)
	else:
		Jacks.set_cell(a.x, a.y-1, 
				Tiles.JACK,
				false, false, false,
				atl_pos)


## component helpers
func set_components_is_in_cycle(og:OrientedGraph):
	for c in components:
		c.is_in_cycle = false
	
	for c in og.get_nodes_in_cycles():
		c.is_in_cycle = true
	
	for c in components:
		if c.is_gate():
			var c_pos = c.get_true_position()
			Gates.set_cell(c_pos.x, c_pos.y, c.get_component_tid())


func place_ghost_component():
	add_component(Component.new(
			GhostComponent.ghost.pivot_position,
			GhostComponent.ghost.type,
			GhostComponent.ghost.direction))


### updates
func setup_layers():
	Technical = $Technical
	Ground = $Ground
	Wires = $Wires
	Walls = $Walls
	Gates = $Gates
	Lights = $Lights
	Labels = $Labels
	Bridges = $Bridges
	Jacks = $Jacks
	Props = $Props


func generate_puzzle(nr_ins:int = 0, nr_outs:int = 0):
	
	if is_generated:
		return
	
	setup_layers()
	
	puzzle_ins.resize(int(min(nr_ins, max_ins)))
	puzzle_outs.resize(int(min(nr_outs, max_outs)))
	
	if Ground.get_used_cells() != null and Ground.get_used_cells().size() != 0:
		generate_parameters_from_puzzle()
	else:
		generate_puzzle_from_parameters()
	
	update_io_state_io_nr()
	
	update_camera_limits()
	
	generate_truth_tables()
	
	from_data(ready_data)
	
	is_generated = true


func generate_parameters_from_puzzle():
	
	# finding map limits
	set_limits(Point.new(
			int(Ground.get_used_rect().end.x), 
			int(Ground.get_used_rect().end.y)))
	
	# generating connections
	_connection_holder = ConnectionHolder.new(limits)
	
	# accounting input and output ports
	for label_pos in Labels.get_used_cells():
	
		var pos := Point.new(label_pos.x, label_pos.y)
		var io := generate_io_from_tile(pos)
		
		if io == null:
			continue
			
		if (io.type == Component.Types.WALL_IN and io.index < puzzle_ins.size()) \
				or (io.type == Component.Types.WALL_OUT and io.index < puzzle_outs.size()):
			add_io(io)
		else:
			remove_io(io)


func generate_puzzle_from_parameters():
	randomize()
	set_limits(Point.new(
			Utils.randi_range(PUtils.MIN_X[dificulty], PUtils.MAX_X[dificulty]),
			Utils.randi_range(PUtils.MIN_Y[dificulty], PUtils.MAX_Y[dificulty])))
	
	# generating connections
	_connection_holder = ConnectionHolder.new(limits)
	
	# grounding
	var p = Point.new()
	for x in range(limits.x):
		p.x = x
		for y in range(limits.y):
			p.y = y
			add_ground_tile(p)

	# rising walls
	for x in range(limits.x):
		p.x = x
		
		p.y = 0
		add_wall_tile(p)
		p.y += 1
		add_wall_tile(p)
		p.y = limits.y - 2 
		add_wall_tile(p)
		p.y += 1
		add_wall_tile(p)
		
	for y in range(2, limits.y - 2):
		p.y = y
		
		p.x = 0
		add_wall_tile(p)
		p.x += 1
		add_wall_tile(p)
		p.x = limits.x - 2 
		add_wall_tile(p)
		p.x += 1
		add_wall_tile(p)
	
	# setting inlets and outlets
	var sides: = range(4)
	sides.shuffle() # [N, E, S, W].shufffle()
	var xs: = range(3, limits.x-3)
	var ys: = range(3, limits.y-3)
	
	xs.shuffle()
	ys.shuffle()
	
	for i in range(puzzle_ins.size()):
		var wall: = Utils.randi_range(0, PUtils.MAX_I_SIDES[dificulty] - 1)
		
		var dir:int = (sides[wall] + 2) % 4
		var pos:Point = get_wall_io_pos(
				xs[i%xs.size()], 
				ys[i%ys.size()], 
				dir)
			
		var wall_in := Component.new(pos, Component.Types.WALL_IN, dir, i)
		add_io(wall_in)
	
	xs.shuffle()
	ys.shuffle()
	
	for o in range(puzzle_outs.size()):
		var wall: = Utils.randi_range(3 - PUtils.MAX_O_SIDES[dificulty] + 1, 3)
		
		var dir:int = (sides[wall] + 2) % 4
		var pos:Point = get_wall_io_pos(
			xs[o%xs.size()], 
			ys[o%ys.size()], 
			dir)
		
		var wall_out := Component.new(pos, Component.Types.WALL_OUT, dir, o)
		add_io(wall_out)


### wires connection abstractisation
func flatten_connections(old_pos:Point, m_pos:Point):
	var old_index:int = _connection_holder.get_connection_index_by_bit(old_pos)
	var m_index:int = _connection_holder.get_connection_index_by_bit(m_pos)
	
	if old_index == -1 and m_index == -1:
		return
	
	if old_index != -1 and m_index != -1:
		_connection_holder.flatten_2_connections(old_index, m_index)
		set_components_is_in_cycle(generate_oriented_graph(_connection_holder))
	
	elif old_index == -1 and m_index != -1:
		var matrix:TrueBitMatrix = generate_wire_matrix_from_point(old_pos)
		if matrix != null:
			var emitters := collect_emitters_for_matrix(matrix)
			var sinks := collect_sinks_for_matrix(matrix)
			var conn := _connection_holder.get_connection(m_index)
			conn.add_matrix_emitters_sinks(matrix, emitters, sinks)
	
	elif old_index != -1 and m_index == -1:
		var matrix:TrueBitMatrix = generate_wire_matrix_from_point(m_pos)
		if matrix != null:
			var emitters := collect_emitters_for_matrix(matrix)
			var sinks := collect_sinks_for_matrix(matrix)
			var conn := _connection_holder.get_connection(old_index)
			conn.add_matrix_emitters_sinks(matrix, emitters, sinks)


func regenerate_connection_matrix():
	for c in puzzle_ins + components + puzzle_outs:
		for l in c.emitters + c.sinks:
			
			if _connection_holder.get_connection_index_by_bit(l.position) == -1 \
					and is_tile_wire(l.position.x, l.position.y):
				
				var matrix := generate_wire_matrix_from_point(l.position)
				if matrix != null:
					var emitters := collect_emitters_for_matrix(matrix)
					var sinks := collect_sinks_for_matrix(matrix)
					_connection_holder.add_connection(matrix, emitters, sinks)
	
	set_components_is_in_cycle(generate_oriented_graph(_connection_holder))
	generate_truth_tables()
	
	if debug:
		if _connection_holder.connections.empty():
			DebugTiles.clear()
		else:
			show_debug(min(index, _connection_holder.connections.size()))


func generate_truth_tables():
	if IOStateObserver.StateHolder == null:
		return
	
	for comp in puzzle_ins + components + puzzle_outs:
		comp.reset_truth_tables()
		
	for conn in _connection_holder.connections:
		conn.is_solved = false 
	
	for conn in _connection_holder.connections:
		if !conn.is_solved:
			conn.solve()
	
	for comp in components:
		comp.set_emitters_truth_tables_from_sinks()
	
	show_lights_for_given_logic_state(IOStateObserver.StateHolder.input_state)
	update_ouput_state()


func update_ouput_state():
	if IOStateObserver.StateHolder == null:
		return
	
	var a := []
	for o in puzzle_outs:
		a.append(o.sinks[0].truth_table)
	for _i in range(4 - puzzle_outs.size()):
		a.append(0)
	
	IOStateObserver.StateHolder.set_output_states(a)


func show_lights_for_given_logic_state(ls:int):
	for comp in puzzle_ins + components + puzzle_outs:
		for l in comp.sinks + comp.emitters:
			l.set_current_logic_state(ls)
			Lights.set_cell(
					l.position.x, l.position.y, 
					l.get_light_tid(), 
					false, false, false, 
					l.get_light_atls_pos())

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
func show_debug(ii:int):
	DebugTiles.clear()
	
	var conn = _connection_holder.get_connection(ii)
	for j in range(conn.matrix.size.y):
		for i in range(conn.matrix.size.x):
			DebugTiles.set_cell(i, j, 0 if conn.matrix.get_bit(Point.new(i, j)) else -1)
		
	for s in conn.sinks:
		DebugTiles.set_cell(s.position.x, s.position.y, 1)

	for e in conn.emitters:
		DebugTiles.set_cell(e.position.x, e.position.y, 2)


func get_grid_mouse_position() -> Point:
	var ret := Point.new(
		int(get_global_mouse_position().x)/PUtils.TILE_SIZE,
		int(get_global_mouse_position().y)/PUtils.TILE_SIZE)
	if get_global_mouse_position().x < 0:
		ret.x -= 1
	if get_global_mouse_position().y < 0:
		ret.y -= 1
	return ret


func get_wall_io_pos(x:int, y:int, dir:int) -> Point:
	var pos: = Point.new(x, y)
	match dir:
		PUtils.SimpleOrientation.S:
			pos.y = 1 
		PUtils.SimpleOrientation.N:
			pos.y = limits.y - 2  
		PUtils.SimpleOrientation.E:
			pos.x = 1
		PUtils.SimpleOrientation.W:
			pos.x = limits.x - 2
	
	return pos


func get_bridged_other_position(p:Point) -> Point:
	if !is_tile_bridge(p.x, p.y):
		return null
	var technical_atl := Technical.get_cell_autotile_coord(p.x, p.y)
	
	if int(technical_atl.x) != 0 || int(technical_atl.y) != 0:
		return Point.new(p.x - int(technical_atl.x), p.y - int(technical_atl.y))
	
	var tid:int = Bridges.get_cell(
			p.x - int(technical_atl.x),
			p.y - int(technical_atl.y))
	
	if tid == Tiles.W_BRIDGE_NS:
		return Point.new(p.x, p.y + 2)
	elif tid == Tiles.W_BRIDGE_EW:
		return Point.new(p.x + 2, p.y)
	return null


func get_true_position_from_technical_tile(p:Point) -> Point:
	if !is_tile_technical(p.x, p.y):
		return null
	var atl = Technical.get_cell_autotile_coord(p.x, p.y)
	return Point.new(p.x - int(atl.x), p.y - int(atl.y))


## graph/connections uitls
func generate_wire_matrix_from_point(start:Point) -> TrueBitMatrix:
	
	if !is_tile_wire(start.x, start.y):
		return null
		
	var matrix:TrueBitMatrix = TrueBitMatrix.new(limits)
	matrix.set_bit(start, true)
	
	var p:Point
	var mo_direction:int
	var stack:Array = [start]
	
	# we have padding so no need to check if we are in limits
	# each wire MultiOrientation matches the neighbours so no need to check if 
	# 	MultiOrientation is correct or if neighbours exist
	while !stack.empty():
		p = stack.pop_back()
		# PUtils.MultiOrientation
		mo_direction = PUtils.get_tile_direction(Wires, p.x, p.y)
		
		if mo_direction & PUtils.MultiOrientation.N != 0:
			var new_p = Point.new(p.x, p.y - 1)
			
			if !matrix.get_bit(new_p):
				matrix.set_bit(new_p, true)
				stack.push_back(new_p)
		
		if mo_direction & PUtils.MultiOrientation.S != 0:
			var new_p = Point.new(p.x, p.y + 1)
		
			if !matrix.get_bit(new_p):
				matrix.set_bit(new_p, true)
				stack.push_back(new_p)
		
		if mo_direction & PUtils.MultiOrientation.W != 0:
			var new_p = Point.new(p.x - 1, p.y)
		
			if !matrix.get_bit(new_p):
				matrix.set_bit(new_p, true)
				stack.push_back(new_p)
		
		if mo_direction & PUtils.MultiOrientation.E != 0:
			var new_p = Point.new(p.x + 1, p.y)
		
			if !matrix.get_bit(new_p):
				matrix.set_bit(new_p, true)
				stack.push_back(new_p)
		
		if is_tile_bridge(p.x, p.y):
			var new_p = get_bridged_other_position(p)
		
			if new_p != null and is_tile_wire(new_p.x, new_p.y) \
					and !matrix.get_bit(new_p):
				matrix.set_bit(new_p, true)
				stack.push_back(new_p)
				
	return matrix


func collect_emitters_for_matrix(m:TrueBitMatrix) -> Array:
	var emitters := []
	
	for c in puzzle_ins + components:
		for e in c.emitters:
			
			if m.get_bit(e.position):
				emitters.append(e)
	
	return emitters


func collect_sinks_for_matrix(m:TrueBitMatrix) -> Array:
	var sinks := []
	
	for c in puzzle_outs + components:
		for s in c.sinks:
	
			if m.get_bit(s.position):
				sinks.append(s)
	
	return sinks


func generate_oriented_graph(ch:ConnectionHolder) -> OrientedGraph:
	
	var og := OrientedGraph.new()
	
	for conn in ch.connections:
		for e in conn.emitters:
			
			var key:Component = e.parent
			
			if !og.graph.has(key):
				og.graph[key] = []
				
			for s in conn.sinks:
				
				var value:Component = s.parent
				
				if !og.graph[key].has(value):
					og.graph[key].append(value)
	
	return og


## utils
func update_io_state_io_nr():
	if IOStateObserver.StateHolder != null:
		IOStateObserver.StateHolder.set_input_nr(puzzle_ins.size())
		IOStateObserver.StateHolder.set_output_nr(puzzle_outs.size())


func update_camera_limits():
	if CameraObserver.ObservedCamera != null:
		CameraObserver.ObservedCamera.reset_cam_limits(limits)


### bools ###
func is_component_placeable(c:Component) -> bool:
	return is_wall_io_placeable(c) \
			or is_gate_placeable(c) \
			or is_bridge_placeable(c)


func is_wall_io_placeable(io:Component) -> bool:
	return io != null \
			and io.is_wall_io() \
			and is_tile_in_limits(io.pivot_position.x, io.pivot_position.y) \
			and !is_tile_wall_io(io.pivot_position.x, io.pivot_position.y) \
			and !is_tile_gate(io.pivot_position.x, io.pivot_position.y) \
			and !is_tile_bridge(io.pivot_position.x, io.pivot_position.y)


func is_gate_placeable(g:Component) -> bool:
	if g == null || !g.is_gate():
		return false
	
	var atls = g.get_technical_atls()
	var true_pos = g.get_true_position()
	
	for a in atls:
		var tech_pos := Point.new(true_pos.x + int(a.x), true_pos.y + int(a.y))
		if !is_tile_in_limits(tech_pos.x, tech_pos.y) \
				or is_tile_wall(tech_pos.x, tech_pos.y) \
				or is_tile_gate(tech_pos.x, tech_pos.y) \
				or is_tile_io(tech_pos.x, tech_pos.y) \
				or is_tile_bridge(tech_pos.x, tech_pos.y):
			return false
	
	return true


func is_bridge_placeable(b:Component) -> bool:
	if b == null || !b.is_bridge():
		return false
	
	var atls = b.get_technical_atls()
	var true_pos = b.get_true_position()
	
	for a in atls:
		var tech_pos := Point.new(true_pos.x + int(a.x), true_pos.y + int(a.y))
		if !is_tile_in_limits(tech_pos.x, tech_pos.y) \
				or is_tile_wall(tech_pos.x, tech_pos.y) \
				or is_tile_gate(tech_pos.x, tech_pos.y) \
				or is_tile_io(tech_pos.x, tech_pos.y) \
				or is_tile_bridge(tech_pos.x, tech_pos.y):
			return false

		if b.type == Component.Types.OVER \
				and (tech_pos.x != true_pos.x or tech_pos.y != true_pos.y) \
				and is_tile_air_ocupied(tech_pos.x, tech_pos.y):
			return false
		
		elif b.type == Component.Types.UNDER \
				and (tech_pos.x == true_pos.x and tech_pos.y == true_pos.y) \
				and is_tile_underground_ocupied(tech_pos.x, tech_pos.y):
			return false
			
	if b.type == Component.Types.OVER:
		if is_tile_air_ocupied(b.pivot_position.x, b.pivot_position.y):
			return false
	
	elif b.type == Component.Types.UNDER \
			and is_tile_underground_ocupied(b.pivot_position.x, b.pivot_position.y):
		return false
		
	return true


# bounds check
func is_tile_in_limits(x:int, y:int) -> bool:
	return 0 <= x && x < limits.x and 0 <= y && y < limits.y


# tile type complex check
func is_tile_wirable(x:int, y:int) -> bool:
	return is_tile_in_limits(x, y) \
		and !is_tile_wall(x, y) \
		and !(is_tile_gate(x, y) and !is_tile_gate_io(x, y))


func is_tile_gate_io(x:int, y:int) -> bool:
	return is_tile_io(x, y) && is_tile_gate(x, y)


func is_tile_io_in(x:int, y:int) -> bool:
	return is_tile_gate_io_in(x, y) || is_tile_wall_io_in(x, y)


func is_tile_io_out(x:int, y:int) -> bool:
	return is_tile_gate_io_out(x, y) || is_tile_wall_io_out(x, y)


func is_tile_air_ocupied(x:int, y:int) -> bool:
	var ret:bool = false
	ret = ret or (Bridges.get_cell(x - 2, y) == Tiles.W_BRIDGE_EW \
				and Bridges.get_cell_autotile_coord(x - 2, y).x == 0)
	ret = ret or (Bridges.get_cell(x - 1, y) == Tiles.W_BRIDGE_EW \
				and Bridges.get_cell_autotile_coord(x - 1, y).x == 0)
	
	ret = ret or (Bridges.get_cell(x, y - 2) == Tiles.W_BRIDGE_NS \
				and Bridges.get_cell_autotile_coord(x, y - 2).x == 0)
	ret = ret or (Bridges.get_cell(x, y - 1) == Tiles.W_BRIDGE_NS \
				and Bridges.get_cell_autotile_coord(x, y - 1).x == 0)
				
	return ret


func is_tile_underground_ocupied(x:int, y:int) -> bool:
	var ret:bool = false
	ret = ret or (Bridges.get_cell(x - 1, y) == Tiles.W_BRIDGE_EW \
				and Bridges.get_cell_autotile_coord(x - 1, y).x == 1)
	ret = ret or (Bridges.get_cell(x, y) == Tiles.W_BRIDGE_EW \
				and Bridges.get_cell_autotile_coord(x, y).x == 1)
	
	ret = ret or (Bridges.get_cell(x, y - 1) == Tiles.W_BRIDGE_NS \
				and Bridges.get_cell_autotile_coord(x, y - 1).x == 1)
	ret = ret or (Bridges.get_cell(x, y ) == Tiles.W_BRIDGE_NS \
				and Bridges.get_cell_autotile_coord(x, y ).x == 1)
				
	return ret


# tile type basic check
func is_tile_wall(x:int, y:int) -> bool:
	return Walls.get_cell(x, y-1) == Tiles.WALL


func is_tile_io(x:int, y:int) -> bool:
	return Lights.get_cell(x, y) != Tiles.EMPTY


func is_tile_gate_io_in(x:int, y:int) -> bool:
	return Lights.get_cell(x, y) == Tiles.LIGHT_GATE_IN


func is_tile_gate_io_out(x:int, y:int) -> bool:
	return Lights.get_cell(x, y) == Tiles.LIGHT_GATE_OUT


func is_tile_wall_io_in(x:int, y:int) -> bool:
	return Lights.get_cell(x, y) == Tiles.LIGHT_WALL_IN


func is_tile_wall_io_out(x:int, y:int) -> bool:
	return Lights.get_cell(x, y) == Tiles.LIGHT_WALL_OUT


func is_tile_wall_io(x:int, y:int) -> bool:
	return Walls.get_cell(x, y-1) == Tiles.WALL_IN_OUT


func is_tile_gate(x:int, y:int) -> bool:
	if Technical.get_cell(x, y) == Tiles.EMPTY:
		return false
	
	var atls:Point = Point.new(
			int(Technical.get_cell_autotile_coord(x, y).x),
			int(Technical.get_cell_autotile_coord(x, y).y))
	
	var true_pos:Point = Point.new(
			x - atls.x,
			y - atls.y)
		
	var tid:int = Gates.get_cell(true_pos.x, true_pos.y)
	
	if (tid == Tiles.G_NOT_NS or tid == Tiles.G_1X2_ERROR) \
			and atls.x == 0 and (atls.y == 1 or atls.y == 2):
		return true
	
	elif (tid == Tiles.G_NOT_EW  or tid == Tiles.G_2X1_ERROR) \
			and atls.y == 1 and (atls.x == 0 or atls.x == 1):
		return true
	
	elif (tid == Tiles.G_AND or tid == Tiles.G_OR or tid == Tiles.G_XOR\
				or tid == Tiles.G_2X2_ERROR) \
			and (atls.x == 0 or atls.x == 1) and (atls.y == 1 or atls.y == 2):
		return true
	
	return false


func is_tile_bridge(x:int, y:int) -> bool:
	if Technical.get_cell(x, y) == Tiles.EMPTY:
		return false
	
	var atls:Point = Point.new(
			int(Technical.get_cell_autotile_coord(x, y).x),
			int(Technical.get_cell_autotile_coord(x, y).y))
	
	var true_pos:Point = Point.new(
			x - atls.x,
			y - atls.y)
	
	#var g_tid:int = Gates.get_cell(true_pos.x, true_pos.y)
	var tid:int = Bridges.get_cell(true_pos.x, true_pos.y)
	
	if tid == Tiles.W_BRIDGE_NS and atls.x == 0 \
			and (atls.y == 0 or atls.y == 2):
		return true
	elif tid == Tiles.W_BRIDGE_EW and atls.y == 0 \
			and (atls.x == 0 or atls.x == 2):
		return true
		
	return false


func is_tile_wire(x:int, y:int) -> bool:
	return Wires.get_cell(x, y) == Tiles.WIRE


func is_tile_jack(x:int, y:int) -> bool:
	return Jacks.get_cell(x, y - 1) == Tiles.JACK


func is_tile_technical(x:int, y:int) -> bool:
	return Technical.get_cell(x, y) == Tiles.TECHNICAL


# tile update check
func is_pair_connectable(t0:Point, t1:Point) -> bool:
	if !is_tile_in_limits(t0.x, t0.y) || !is_tile_in_limits(t1.x, t1.y):
		return false
		
	if !is_tile_wirable(t0.x, t0.y) || !is_tile_wirable(t1.x, t1.y):
		return false
	
	if !PUtils.are_adjacent(t0, t1):
		return false
	
	if is_tile_io(t0.x, t0.y):
		if (PUtils.get_tile_direction(Lights, t0.x, t0.y) \
				!= PUtils.get_a_towards_b_dir_so(t0, t1)):
			return false
	
	if is_tile_io(t1.x, t1.y):
		if (PUtils.get_tile_direction(Lights, t1.x, t1.y) \
				!= PUtils.get_a_towards_b_dir_so(t1, t0)):
			return false
	
	return true


func is_a_connected_with_b(a:Point, b:Point) -> bool:
	var v:int = PUtils.get_tile_direction(Wires, a.x, a.y)
	v &= PUtils.get_a_towards_b_dir_mo(a, b)
	return is_pair_connectable(a, b) and v != 0


func is_a_plugable_in_b(a:Point, b:Point) -> bool:
	return  is_a_connected_with_b(a, b) \
		and !is_tile_io(a.x, a.y) \
		and is_tile_io(b.x, b.y)


func is_connected_this_way(t:Point, so_dir:int) -> bool:
	if !is_tile_wire(t.x, t.y):
		return false
	
	var mo_dir := PUtils.so_to_mo(so_dir)
	var tile_dir := int(Wires.get_cell_autotile_coord(t.x, t.y).x)
	return tile_dir & mo_dir != 0

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	var components_data := []
	
	for c in components + bridges:
		components_data.append(c.to_data())
	
	return {
		"wires": Wires.to_data(),
		"components": components_data
	}


func from_data(data:Dictionary):
	
	for c in components + bridges:
		remove_component(c)
	
	if data.has("wires"):
		Wires.from_data(data.wires)
		regenerate_connection_matrix()
	
	if data.has("components"):
		for cd in data.components:
		
			var c := Component.new()
			c.from_data(cd)
			add_component(c, false) # do not decrement when adding


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####

# CameraWatcherFuncs
func on_camera_holder_change():
	
	if CameraObserver.ObservedCamera == null:
		return
		
	CameraObserver.ObservedCamera.reset_cam_limits(limits)


# PuzzleIOStateWatcherFuncs
func on_io_state_holder_change():
	update_io_state_io_nr()
	generate_truth_tables()


func on_input_state_change():
	show_lights_for_given_logic_state(IOStateObserver.StateHolder.input_state)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
