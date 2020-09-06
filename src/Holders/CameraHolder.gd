class_name CameraHolder extends Camera2D

#### VARS ####

# enums
# consts

# settings
export var player_binded:bool = false
export var zoom_speed:float = 0.05
export var min_zoom:float = 0.25
export var max_zoom:float = 0.75
export var start_zoom:float = 0.50
export var zoom_time:float = 0.25
export var ZERO:float = 0.0005
export var margin:int = 15
export var viteza:int = 800

# singletons
# nodes

# public
var limits_ne:Vector2
var limits_sw:Vector2
var moving_camera:bool = false
var puzzle_center:Vector2 = Vector2.ZERO

# private
var _target_zoom:Vector2 setget set_target_zoom
var _mouse_anchor:Vector2
var _old_viewport_size:Vector2

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	_old_viewport_size = get_viewport().size
	
	var _err = get_viewport().connect("size_changed", self, "_on_Viewport_size_changed")
	reset_cam_zoom()
	
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME,
			Groups.CAMERA_HOLDERS,
			Groups.CameraHolderFuncs.ON_CAMERA_HOLDER_CHANGE)
	add_to_group(Groups.CAMERA_HOLDERS)
	get_tree().call_group(Groups.CAMERA_WATCHERS,
			Groups.CameraWatcherFuncs.ON_CAMERA_HOLDER_CHANGE,
			self)
	
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)


func _input(event:InputEvent):
	
	if not current:
		return
	
	if not(event is InputEventMouseButton):
		return
		
	if Input.is_action_just_pressed("camera_drag"):
		_mouse_anchor = get_global_mouse_position()
		
	var z: = Input.get_action_strength("zoom_in") - Input.get_action_strength("zoom_out")
	if z != 0:
		z = z * zoom_speed
		var new_zoom = _target_zoom - Vector2(z, z)
		set_target_zoom(new_zoom)


func _physics_process(_delta: float):
	
	if not current:
		return
	
	move_camera()
	drag_camera()
	zoom_camera()

#--#MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters

# updates
func drag_camera():
	if !is_camera_dragged():
		return
	var new_pos = global_position - (get_global_mouse_position() - _mouse_anchor)
	global_position = clamp_pos(new_pos)


func move_camera():
	var delta: = get_physics_process_delta_time()
	var directie: = get_sens()
	var new_pos = global_position + directie * delta * viteza * zoom
	if new_pos != global_position:
		global_position = clamp_pos(new_pos)


func center_camera(limits:Point):

	puzzle_center = Vector2(
			limits.x * PUtils.TILE_SIZE / 2.0,
			limits.y * PUtils.TILE_SIZE / 2.0
		) - get_viewport().size / 2 * zoom

	position = puzzle_center


func zoom_camera():
	if zoom == _target_zoom:
		return
	var delta: = get_physics_process_delta_time()
	var new_zoom = zoom.linear_interpolate(_target_zoom, delta/zoom_time)
	if abs(_target_zoom.x - new_zoom.x) < ZERO:
		new_zoom.x = _target_zoom.x
	if abs(_target_zoom.y - new_zoom.y) < ZERO:
		new_zoom.y = _target_zoom.y
	var new_pos:Vector2 = get_cam_new_pos_for_zoom_to_mouse(new_zoom)
	zoom = new_zoom
	reset_limits_ne()
	global_position = clamp_pos(new_pos)
	scale = zoom * 2


func reset_cam_limits(limits:Point):
	reset_limits_ne()
	reset_limits_sw(limits)
	center_camera(limits)
	reset_cam_zoom()


func reset_limits_ne():
	limits_ne = Vector2(
			4 * PUtils.TILE_SIZE,
			4 * PUtils.TILE_SIZE
		) - get_viewport().size * zoom


func reset_limits_sw(limits:Point):
	limits_sw = Vector2(
			(limits.x - 4) * PUtils.TILE_SIZE,
			(limits.y - 4) * PUtils.TILE_SIZE
		)


func set_target_zoom(n_zoom:Vector2):
	var new_zoom = Vector2(n_zoom)
	if new_zoom.x > max_zoom || new_zoom.y > max_zoom:
		new_zoom.x = max_zoom
		new_zoom.y = max_zoom
	elif new_zoom.x < min_zoom || new_zoom.y < min_zoom:
		new_zoom.x = min_zoom
		new_zoom.y = min_zoom
	_target_zoom = new_zoom


func adjust_camera_center():
	var dif:Vector2 = _old_viewport_size - get_viewport().size
	var new_pos:Vector2 = global_position + (dif / 4.0)
	reset_limits_ne()
	global_position = clamp_pos(new_pos)
	_old_viewport_size = get_viewport().size


func reset_cam_zoom():
	_target_zoom = Vector2(start_zoom, start_zoom)
	zoom = _target_zoom

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### utils ###
func clamp_pos(pos:Vector2) -> Vector2:
	var new_pos: = Vector2(pos)
	if new_pos.x < limits_ne.x:
		new_pos.x = limits_ne.x
	elif new_pos.x > limits_sw.x:
		new_pos.x = limits_sw.x
	if new_pos.y < limits_ne.y:
		new_pos.y = limits_ne.y
	elif new_pos.y > limits_sw.y:
		new_pos.y = limits_sw.y
	return new_pos


func get_sens() -> Vector2:
	return Vector2(
		Input.get_action_strength("player_est") - Input.get_action_strength("player_west"),
		Input.get_action_strength("player_south") - Input.get_action_strength("player_north"))


func get_cam_new_pos_for_zoom_to_mouse(new_zoom:Vector2) -> Vector2:
	return global_position + get_local_mouse_position() * (zoom - new_zoom)


### bools ###
func is_camera_dragged() -> bool:
	return Input.is_action_pressed("camera_drag")

#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

## CameraHolderFuncs
func on_camera_holder_change():
	remove_from_group(Groups.CAMERA_HOLDERS)


func on_node_is_ready(n:Node):
	if n.has_method(Groups.CameraWatcherFuncs.ON_CAMERA_HOLDER_CHANGE):
		n.call(Groups.CameraWatcherFuncs.ON_CAMERA_HOLDER_CHANGE, self)


## PausableFuncs
func on_view_case_change():
	
	current = true if not PuzzleOverview.view_case_to_paused(SceneManager.view_case) else current
	adjust_camera_center()
	pause_mode = Node.PAUSE_MODE_STOP \
			if not current \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, not current)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Viewport_size_changed():
	reset_limits_ne()
	adjust_camera_center()

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
