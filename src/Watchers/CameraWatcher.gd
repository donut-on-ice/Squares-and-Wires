class_name CameraWatcher extends Node

#### VARS ####

# enums
# consts
# settings
# singletons

# nodes
var ObservedCamera:CameraHolder setget set_camera_holder
var Parent:Node
var this_node = self

# public
# private
var notify_parent:bool = false setget set_notify_parent

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	add_to_group(Groups.CAMERA_WATCHERS)
	get_tree().call_group(Groups.CAMERA_HOLDERS,
			Groups.CameraHolderFuncs.ON_NODE_IS_READY,
			self)


func _enter_tree() -> void:
	Parent = get_parent()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_notify_parent(b:bool) -> void:
	notify_parent = b
	if notify_parent:
		update_camera_holder()


func set_camera_holder(ch:CameraHolder) -> void:
	ObservedCamera = ch
	update_camera_holder()


# updates

func update_camera_holder() -> void:
	if !is_inside_tree():
		return

	if notify_parent and Parent != null:
		if Parent.has_method(Groups.CameraWatcherFuncs.ON_CAMERA_HOLDER_CHANGE):
			Parent.call(Groups.CameraWatcherFuncs.ON_CAMERA_HOLDER_CHANGE)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_camera_holder_change(ch:CameraHolder) -> void:
	set_camera_holder(ch)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
