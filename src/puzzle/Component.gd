class_name Component extends Resource

#### VARS ####

# enums
enum Types {NOT, AND, OR, XOR, OVER, UNDER, WALL_IN, WALL_OUT ,NONE}

# consts
const MASK_1010:int = 0xAAAAAAAA
const MASK_0101:int = 0x55555555
const MASK_32_BITS:int = 0xFFFFFFFF
const TILE_SET:TileSet = preload("res://assets/tilesets/PuzzleTileset.tres")
var Tiles := {
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
# singletons
# nodes
# public
var pivot_position:Point
var type:int # PUtils.Types
var direction:int # PUtils.SimpleOrientation
var sinks:Array # [IOlight]
var emitters:Array # [IOlight]
var is_in_cycle:bool = false

# private
var index:int = 0

# signals
#--# VARS #--#



#### MAIN METHODS ####
# pivot: tile where mouse is when component is placed/snaped
# t: Types
# d: PUtils.SimpleOrientation
func _init(pivot:Point = Point.new(), t:int = Types.NONE, d:int = PUtils.SimpleOrientation.E, i:int = -1):
	pivot_position = pivot
	type = t
	direction = d
	index = i
	sinks = []
	emitters = []
	
	if is_gate():
		if type == Types.NOT:
			add_2x1_lights()
		else:
			add_2x2_lights()
	elif type == Types.WALL_IN:
		emitters.append(
				IOLight.new(self,
					pivot_position,
					PUtils.LogicState.OFF,
					direction,
					true, # is wall?
					true)) # is input?
	elif type == Types.WALL_OUT:
		sinks.append(
				IOLight.new(self,
					pivot_position,
					PUtils.LogicState.OFF,
					direction,
					true, # is wall?
					false)) # is input?

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

## setters
func add_to_sink_truth_table_from_an_emmiter(e:IOLight, sink_index:int):
	if e == null || !e.is_emmiter():
		return
	if is_in_cycle:
		sinks[sink_index] = IOLight.CYCLE_TRUTH_TABLE
	sinks[sink_index] |= e.truth_table


func reset_truth_tables():
	for l in sinks + emitters:
		l.reset_truth_table()
	
	if type == Types.WALL_IN:
		_apply_static_to_emmiter()
	elif is_gate() and is_in_cycle:
		_apply_in_cycle_to_emitter()


func set_emitters_truth_tables_from_sinks():
	if not is_gate():
		return 
		
	if is_in_cycle:
		_apply_in_cycle_to_emitter()
		return
	
	match type:
		Types.AND:
			_apply_and_to_emmiter()
		Types.OR:
			_apply_or_to_emitter()
		Types.XOR:
			_apply_xor_to_emitter()
		Types.NOT:
			_apply_not_to_emitter()


# updates
func add_2x1_lights():
	# out 1
	var light_position = Point.new(pivot_position.x, pivot_position.y)
	
	var l_dir:int = PUtils.SimpleOrientation.S
	match direction:
		PUtils.SimpleOrientation.E:
			l_dir = PUtils.SimpleOrientation.W
			light_position.x += 1
		PUtils.SimpleOrientation.W:
			l_dir = PUtils.SimpleOrientation.E
			light_position.x -= 1
		PUtils.SimpleOrientation.S:
			l_dir = PUtils.SimpleOrientation.N
			light_position.y += 1
		PUtils.SimpleOrientation.N:
			l_dir = PUtils.SimpleOrientation.S
			light_position.y -= 1
	
	var light := IOLight.new(self,
			light_position,
			PUtils.LogicState.OFF,
			direction,
			false, # is wall?
			false) # is input?
	emitters.append(light)
	
	# in 1
	light = IOLight.new(self,
			pivot_position,
			PUtils.LogicState.OFF,
			l_dir,
			false, # is wall?
			true) # is input?
	sinks.append(light)


func add_2x2_lights():
	# out 1
	# in 1
	add_2x1_lights()
	
	# in 2
	var light_position :=  Point.new(pivot_position.x, pivot_position.y)
	var l_dir:int = PUtils.SimpleOrientation.S
	match direction:
		PUtils.SimpleOrientation.E:
			l_dir = PUtils.SimpleOrientation.W
			light_position.y += 1
		PUtils.SimpleOrientation.W:
			l_dir = PUtils.SimpleOrientation.E
			light_position.y -= 1
		PUtils.SimpleOrientation.S:
			l_dir = PUtils.SimpleOrientation.N
			light_position.x -= 1
		PUtils.SimpleOrientation.N:
			l_dir = PUtils.SimpleOrientation.S
			light_position.x += 1

	var light := IOLight.new(self,
			light_position,
			PUtils.LogicState.OFF,
			l_dir,
			false, # is wall?
			true) # is input?
	sinks.append(light)


# emitters truth tables
func _correct_emiiter():
	emitters[0].truth_table |= _get_mask_xx00_or_00xx_or_xx11_or_11xx()
	emitters[0].truth_table &= _get_mask_not_0000()
	emitters[0].lock_truth_table()


func _apply_static_to_emmiter():
	emitters[0].set_fixed_input(index)
	emitters[0].lock_truth_table()


func _apply_in_cycle_to_emitter():
	emitters[0].set_cycle_truth_table()
	emitters[0].lock_truth_table()


func _apply_and_to_emmiter():
	var s0 = sinks[0].truth_table
	var s1 = sinks[1].truth_table
	emitters[0].truth_table = ((s0 & s1) & MASK_1010) | ((s0 | s1) & MASK_0101)
	_correct_emiiter()
	
	
func _apply_or_to_emitter():
	var s0 = sinks[0].truth_table
	var s1 = sinks[1].truth_table
	emitters[0].truth_table = ((s0 | s1) & MASK_1010) | ((s0 & s1) & MASK_0101)
	_correct_emiiter()
	
	
func _apply_xor_to_emitter():
	var s0 = sinks[0].truth_table
	var s1 = sinks[1].truth_table
	emitters[0].truth_table = ((s0 ^ s1) & MASK_1010) | (~(s0 ^ s1) & MASK_0101)
	_correct_emiiter()


func _apply_not_to_emitter():
	var s0 = sinks[0].truth_table
	emitters[0].truth_table = ((s0 & MASK_0101) << 1) | ((s0 & MASK_1010) >> 1)
	emitters[0].lock_truth_table()

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_true_position() -> Point:
	var ret = Point.new(pivot_position.x, pivot_position.y)
	if is_gate():
		if type == Types.NOT:
			match direction:
				PUtils.SimpleOrientation.E:
					ret.y -= 1
				PUtils.SimpleOrientation.S:
					ret.y -= 1
				PUtils.SimpleOrientation.W:
					ret.x -= 1
					ret.y -= 1
				PUtils.SimpleOrientation.N:
					ret.y -= 2
		else:
			match direction:
				PUtils.SimpleOrientation.E:
					ret.y -= 1
				PUtils.SimpleOrientation.W:
					ret.x -= 1
					ret.y -= 2
				PUtils.SimpleOrientation.S:
					ret.x -= 1
					ret.y -= 1
				PUtils.SimpleOrientation.N:
					ret.y -= 2
	elif is_wall_io():
		ret.y -= 1
	elif is_bridge():
		match direction:
			PUtils.SimpleOrientation.E:
				ret.x -= 1
			PUtils.SimpleOrientation.W:
				ret.x -= 1
			PUtils.SimpleOrientation.S:
				ret.y -= 1
			PUtils.SimpleOrientation.N:
				ret.y -= 1
	return ret


func _get_mask_not_0000() -> int:
	var s0 = sinks[0].truth_table
	var s1 = sinks[1].truth_table
	var r = ((s0 & MASK_1010) >> 1) | (s0 & MASK_0101) \
			| ((s1 & MASK_1010) >> 1) | (s1 & MASK_0101)
	return r | (r << 1)


func _get_mask_xx00_or_00xx_or_xx11_or_11xx() -> int:
	var s0 = sinks[0].truth_table
	var s1 = sinks[1].truth_table
	var r = (((s0 & MASK_1010) >> 1) ^ (s0 & MASK_0101)) \
			& (((s1 & MASK_1010) >> 1) ^ (s1 & MASK_0101))
	return ~(r | (r << 1)) & MASK_32_BITS


func get_component_tid() -> int:
	if is_bridge():
		if direction == PUtils.SimpleOrientation.N \
				or direction == PUtils.SimpleOrientation.S:
			return Tiles.W_BRIDGE_NS
		elif direction == PUtils.SimpleOrientation.W \
				or direction == PUtils.SimpleOrientation.E:
			return Tiles.W_BRIDGE_EW
	
	if is_wall_io():
		return Tiles.WALL_IN_OUT
		
	match type:
		Types.AND:
			return Tiles.G_AND if !is_in_cycle else Tiles.G_2X2_ERROR
		Types.OR:
			return Tiles.G_OR if !is_in_cycle else Tiles.G_2X2_ERROR
		Types.XOR:
			return Tiles.G_XOR if !is_in_cycle else Tiles.G_2X2_ERROR
		Types.NOT: 
			if direction == PUtils.SimpleOrientation.N \
					or direction == PUtils.SimpleOrientation.S:
				return Tiles.G_NOT_NS if !is_in_cycle else Tiles.G_1X2_ERROR
			elif direction == PUtils.SimpleOrientation.W \
					or direction == PUtils.SimpleOrientation.E:
				return Tiles.G_NOT_EW if !is_in_cycle else Tiles.G_2X1_ERROR

	return Tiles.EMPTY


func get_component2_tid() -> int:
	
	if is_1x2():
		return Tiles.G_1X2_NS
	
	elif is_2x1():
		return Tiles.G_2X1_EW
	
	elif is_2x2():
	
		match direction:
	
			PUtils.SimpleOrientation.E:
				return Tiles.G_2X2_EW
	
			PUtils.SimpleOrientation.W:
				return Tiles.G_2X2_EW
	
			PUtils.SimpleOrientation.S:
				return Tiles.G_2X2_S
	
			PUtils.SimpleOrientation.N:
				return Tiles.G_2X2_N
	
	return Tiles.EMPTY


func get_empty_spot() -> Point:
	if !is_gate() or type == Types.NOT:
		return null
	
	var p := Point.new(pivot_position.x, pivot_position.y)
	
	match direction:
		PUtils.SimpleOrientation.E:
			p.x += 1
			p.y += 1
			return p
		PUtils.SimpleOrientation.W:
			p.x -= 1
			p.y -= 1
			return p
		PUtils.SimpleOrientation.S:
			p.x -= 1
			p.y += 1
			return p
		PUtils.SimpleOrientation.N:
			p.x += 1
			p.y -= 1
			return p
	
	return null


func get_component_atlas_position() -> Vector2:
	if is_wall_io():
		return Vector2(direction, 0)
	
	if type == Types.OVER:
		return Vector2.ZERO
	
	elif type == Types.UNDER: 
		return Vector2(1, 0)
		
	return Vector2.ZERO


func get_technical_atls() -> Array:
	var atls := []
	if is_gate():
		if type == Types.NOT:
			atls.append(Vector2(0, 1))
			if direction == PUtils.SimpleOrientation.S \
					or direction == PUtils.SimpleOrientation.N:
				atls.append(Vector2(0, 2))
			elif direction == PUtils.SimpleOrientation.E \
					or direction == PUtils.SimpleOrientation.W:
				atls.append(Vector2(1, 1))
		
		else:
			atls.append(Vector2(0, 1))
			atls.append(Vector2(0, 2))
			atls.append(Vector2(1, 1))
			atls.append(Vector2(1, 2))
		
	if is_wall_io():
		atls.append(Vector2(0, 1))
		
	if is_bridge():
		atls.append(Vector2(0, 0))
		if direction == PUtils.SimpleOrientation.S \
				or direction == PUtils.SimpleOrientation.N:
			atls.append(Vector2(0, 2))
		elif direction == PUtils.SimpleOrientation.E \
				or direction == PUtils.SimpleOrientation.W:
			atls.append(Vector2(2, 0))
	
	return atls

### bools ###
func is_gate() -> bool:
	return type == Types.AND \
			or type == Types.OR \
			or type == Types.XOR \
			or type == Types.NOT


func is_wall_io() -> bool:
	return type == Types.WALL_IN \
			or type == Types.WALL_OUT
	

func is_bridge() -> bool:
	return type == Types.OVER \
			or type == Types.UNDER


func is_1x1() -> bool:
	return type == Types.WALL_IN \
		or type == Types.WALL_OUT


func is_1x2() -> bool:
	return type == Types.NOT \
		and (direction == PUtils.SimpleOrientation.S \
			or direction == PUtils.SimpleOrientation.N)


func is_1x3() -> bool:
	return (type == Types.UNDER \
			or type == Types.OVER) \
		and (direction == PUtils.SimpleOrientation.S \
			or direction == PUtils.SimpleOrientation.N)


func is_2x1() -> bool:
	return type == Types.NOT \
		and (direction == PUtils.SimpleOrientation.E \
			or direction == PUtils.SimpleOrientation.W)


func is_2x2() -> bool:
	return type == Types.AND \
		or type == Types.OR \
		or type == Types.XOR


func is_3x1() -> bool:
	return (type == Types.UNDER \
			or type == Types.OVER) \
		and (direction == PUtils.SimpleOrientation.E \
			or direction == PUtils.SimpleOrientation.W)

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	return {	
		"pivot_position": pivot_position.to_data(),
		"type": type,
		"direction": direction,
		"index": index
	}


func from_data(data:Dictionary):
	
	if data.has("pivot_position"): pivot_position.from_data(data.pivot_position)
	if data.has("type"): type = data.type
	if data.has("direction"): direction = data.direction
	if data.has("index"): index = data.index
	
	sinks = []
	emitters = []
	
	if is_gate():
		if type == Types.NOT:
			add_2x1_lights()
		else:
			add_2x2_lights()
	elif type == Types.WALL_IN:
		emitters.append(
				IOLight.new(self,
					pivot_position,
					PUtils.LogicState.OFF,
					direction,
					true, # is wall?
					true)) # is input?
	elif type == Types.WALL_OUT:
		sinks.append(
				IOLight.new(self,
					pivot_position,
					PUtils.LogicState.OFF,
					direction,
					true, # is wall?
					false)) # is input?


#--# DATA METHODS #--#



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
