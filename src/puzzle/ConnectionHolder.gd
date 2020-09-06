class_name ConnectionHolder extends Resource

#### VARS ####

# enums
# consts
# settings
# singletons
# nodes
# public
var limits:Point = Point.new() setget set_limits
var connections:Array = []

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _init(l:Point) -> void:
	set_limits(l)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_limits(l:Point) -> void:
	limits.x = l.x
	limits.y = l.y
	for c in connections:
		c.matrix.set_size(limits)


func set_connection_bit(p:Point, c_index:int, value:bool = true) -> void:
	connections[c_index].matrix.set_bit(p, value)
	if !value and connections[c_index].matrix.is_full_of_zero():
		connections.remove(c_index)


# updates
func set_new_connection_bit(p:Point) -> void:
	connections.append(ConnectionWrapper.new(self, TrueBitMatrix.new(limits)))
	connections[-1].matrix.set_bit(p, true)


func flatten_2_connections(c1_index:int, c2_index:int) -> void:
	if c1_index == c2_index:
		return
	
	var m = min(c1_index, c2_index)
	var M = max(c1_index, c2_index)
	connections[m].matrix.add_matrix(connections[M].matrix)
	
	for e in connections[M].emitters:
		if !connections[m].emitters.has(e):
			connections[m].emitters.append(e)
			
	for s in connections[M].sinks:
		if !connections[m].sinks.has(s):
			connections[m].sinks.append(s)
	
	connections.remove(M)


func add_connection(matrix:TrueBitMatrix, e:Array, s:Array) -> void:
	if matrix.is_full_of_zero():
		return
	if matrix.size.x != limits.x or matrix.size.y != limits.y:
		return
	var conn := ConnectionWrapper.new(self, matrix)
	conn.emitters = e
	conn.sinks = s
	connections.append(conn)


func remove_connection_by_bit(b:Point) -> void:
	var i := get_connection_index_by_bit(b)
	if i != -1:
		remove_connection(i)


func remove_connection(index:int) -> void:
	connections.remove(index)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###

# returns index of first mask with said bit true
func get_connection_index_by_bit(p:Point) -> int:
	for i in range(connections.size()):
		if connections[i].matrix.get_bit(p):
			return i
	return -1


func get_connection(index:int) -> ConnectionWrapper:
	return connections[index]


### bools ###
# returns value of give bit from a connection
func get_bit_from_connection(p:Point, c_index:int) -> bool:
	return connections[c_index].matrix.get_bit(p)


func connections_are_valid() -> bool:
	var matrix_acumulator:TrueBitMatrix = TrueBitMatrix.new(limits)
	for c in connections:
		if !matrix_acumulator.has_no_overlapping_bit_with_matrx_else_add_matrix(c):
			return false
	return true

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
class ConnectionWrapper:
	var parent
	var matrix:TrueBitMatrix
	var emitters:Array
	var sinks:Array
	var is_solved:bool
	
	func _init(par, m:TrueBitMatrix) -> void:
		parent = par
		matrix = m
		emitters = []
		sinks = []
		is_solved = false
	
	
	func add_matrix_emitters_sinks(m:TrueBitMatrix, es:Array, ss:Array) -> void:
		matrix.add_matrix(m)
		emitters += es
		sinks += ss
	
	
	func solve() -> void:
		
		for e in emitters:
		
			if !e.is_truth_table_set:
		
				for s in e.parent.sinks:
		
					if !s.is_truth_table_set:
		
						var i:int = parent.get_connection_index_by_bit(s.position)
		
						if i == TrueBitMatrix.NO_CONNECTION:
							continue
						
						var conn = parent.get_connection(i)
						if !conn.is_solved:
							conn.solve()
		
				e.parent.set_emitters_truth_tables_from_sinks()
			
			for s in sinks:
				s.truth_table |= e.truth_table
		
		for s in sinks:
			s.is_truth_table_set = true
		
		is_solved = true
#--# CLASSES #--#
