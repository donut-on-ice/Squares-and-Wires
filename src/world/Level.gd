class_name Level extends Node2D

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
onready var terrain:Terrain = $Terrain
onready var transparency_map:TransparencyMap = $Terrain/TransparencyMap
onready var path_map:PathMap = $Terrain/Navigation2D/PathMap
onready var objects:ObjectManager = $Objects
onready var allies:Allies = $Objects/Mobs/Allies
onready var bugs:Bugs = $Objects/Mobs/Bugs
onready var fog:Fog = $Fog
onready var player:Player = $Objects/Mobs/Allies/Player
onready var Nav2D:Navigation2D = $Terrain/Navigation2D

# public
# private
var packed_level:PackedLevel = null

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	LevelManager.Nav2D = Nav2D
	
	if player != null:
		player.fog = fog if player.fog == null else player.fog

	fog.update_bitmask_region()

	if packed_level != null:
		LevelManager.apply_save_data(packed_level)

	on_view_case_change()
	add_to_group(Groups.PAUSABLES)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.INVENTORY \
			and vc != SceneManager.Cases.LOCKPAD \
			and vc != SceneManager.Cases.MAP \
			and vc != SceneManager.Cases.UPGRADE_TABLE \
			and vc != SceneManager.Cases.CONTROL_BOARD

### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	var paused := view_case_to_paused(SceneManager.view_case)
	visible = not paused and SceneManager.view_case != SceneManager.Cases.CONTROL_BOARD
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
