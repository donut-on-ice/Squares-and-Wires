class_name TrueBitMatrix extends Resource

#### VARS ####
# enums
# consts
const INT_BITS:int = 32
const INT_MASK:int = 0x0000001F
const INT_BITS_POW2:int = 5
const NO_CONNECTION:int = -1

# settings
# singletons
# nodes
# public
var size:Point = Point.new(0, 0)

# private
var _matrix:Array = []

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _init(p:Point) -> void:
	set_size(p)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_size(p:Point) -> void:
	set_size_x(p.x)
	set_size_y(p.y)


func set_size_x(x:int) -> void:
	
	if size.x == x:
		return
	
	var big_x:int = x >> INT_BITS_POW2
	var big_size_x:int = size.x >> INT_BITS_POW2
	
	for a in _matrix:
		a.resize(big_x + 1)
		if big_size_x < big_x:
			for i in range(big_size_x, big_x):
				a[i] = 0
	
	size.x = x


func set_size_y(y:int) -> void:
	
	if size.y == y:
		return
	
	_matrix.resize(y)
	
	if size.y < y:
		for j in range(size.y, y):
			var a := PoolIntArray()
			a.resize((size.x >> INT_BITS_POW2) + 1)
			for i in range((size.x >> INT_BITS_POW2) + 1):
				a[i] = 0
			_matrix[j] = a
	
	size.y = y


func set_bit(p:Point, bit:bool = true) -> void:
	var x_small = p.x & INT_MASK
	var x_big = p.x >> INT_BITS_POW2
	if bit:
		_matrix[p.y][x_big] = _matrix[p.y][x_big] | (1 << x_small)
	else:
		_matrix[p.y][x_big] = _matrix[p.y][x_big] & ~(1 << x_small)


# updates
func negate_bits() -> void:
	
	var big_size_x:int = size.x >> INT_BITS_POW2
	var small_size_x = size.x & INT_MASK
	
	var mask:int = 0
	for _i in range(small_size_x):
		mask = mask << 1
		mask |= 1
	
	for y in range(size.y):
		for x_big in range(big_size_x + 1):
			_matrix[y][x_big] = ~_matrix[y][x_big]
		_matrix[y][big_size_x] &= mask


# should have the same size
func add_matrix(other:TrueBitMatrix) -> void:
	for y in range(size.y):
		for x_big in range((size.x >> INT_BITS_POW2) + 1):
			_matrix[y][x_big] |= other._matrix[y][x_big]


func has_no_overlapping_bit_with_matrx_else_add_matrix(other:TrueBitMatrix) -> bool:
	for y in range(size.y):
		for x_big in range((size.x >> INT_BITS_POW2) + 1):
			if _matrix[y][x_big] & other._matrix[y][x_big] != 0:
				return false
			_matrix[y][x_big] |= other._matrix[y][x_big]
	return true

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
func is_full_of_zero() -> bool:
	for y in range(size.y):
		for x_big in range((size.x >> INT_BITS_POW2) + 1):
			if _matrix[y][x_big] != 0:
				return false
	return true


### bools ###
func get_bit(p:Point) -> bool:
	var x_small = p.x & INT_MASK
	var x_big = p.x >> INT_BITS_POW2
	return _matrix[p.y][x_big] & (1 << x_small) != 0


func is_connected_to_matrix(other:TrueBitMatrix) -> bool:
	if other.size.x != size.x or other.size.y != size.y:
		return false
	
	var are_connected = false
	for y in range(size.y):
		for x_big in range((size.x >> INT_BITS_POW2) + 1):
			are_connected = _matrix[y][x_big] & other._matrix[y][x_big] != 0
			if are_connected:
				break
		if are_connected:
			break
	return are_connected

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#

