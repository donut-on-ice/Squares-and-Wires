class_name AutoWalkPath extends Resource

#### VARS ####

# enums
# consts
# settings
# singletons
# nodes
# public
var path := PoolVector2Array([])
var path_index := 0
var NEAR_ZERO := 8.0
var NEAR_DESTINATION := 8.0

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func _init(near_zero:float = 5.0, near_destination:float = 5.0):
	NEAR_ZERO = near_zero
	NEAR_DESTINATION = max(near_destination, near_zero)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func simple_path(_start:Vector2, destination:Vector2):
	path_index = 0
	path = PoolVector2Array([destination])
	skip_near_destination_path_points()


func from_nav2d(start:Vector2, destination:Vector2):
	path = LevelManager.Nav2D.get_simple_path(start, destination, true) \
			if LevelManager.Nav2D != null \
			else PoolVector2Array([])
	path_index = 0
	skip_near_destination_path_points()


func clear():
	path.resize(0)
	path_index = 0


### updates ###
func skip_near_destination_path_points():
	
	if empty():
		return
		
	var index = path_index
	while end().distance_to(path[index]) >= NEAR_DESTINATION and index < path.size():
		index += 1
		
	path[index] = end()
	path.resize(index + 1)


func skip_close_path_points(position:Vector2):
	
	while true:
		
		if empty():
			return
		
		if position.distance_to(path[path_index]) >= NEAR_ZERO:
			if path_index != path.size() - 1:
				return
			elif position.distance_to(end()) >= NEAR_DESTINATION:
				return
		
		path_index += 1

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func end() -> Vector2:
# warning-ignore:incompatible_ternary
	return path[path.size() - 1] if not path.empty() else null


### bools ###
func empty() -> bool:
	return path_index >= path.size()


func is_point_destination(point:Vector2) -> bool:
	return point.distance_squared_to(end()) < NEAR_DESTINATION if not path.empty() else false


### utils ###
func acceleration_from(position:Vector2) -> Vector2:
	
	skip_close_path_points(position)
	
	if empty():
		return Vector2.ZERO
	
	return (path[path_index] - position).normalized()

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	return {
		"path": path,
		"path_index": path_index,
		"near_zero": NEAR_ZERO,
		"near_destination": NEAR_DESTINATION,
	}


func from_data(data:Dictionary):
	
	if not data.has_all(["path", "path_index", "near_zero", "near_destination", "destination_index"]):
		return
	
	path = data.path
	path_index = data.path_index
	NEAR_ZERO = data.near_zero
	NEAR_DESTINATION = data.near_destination

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
