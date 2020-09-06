class_name Robo extends Mob

#### VARS ####

# enums
# consts
const in_world_size := 16

# settings
export(NodePath) var transparency_map_path:String = "../../../../Terrain/TransparencyMap"
export(NodePath) var fog_path:String = "../../../../Fog"
export(int) var radio_range := 5

# singletons
# nodes
onready var transparency_map:TransparencyMap = get_node(transparency_map_path)
onready var fog:Fog = get_node(fog_path)
onready var RSM:RoboStateMachine = $AnimationTree
onready var AutoAttack:HitArea = $HitAreaHands

# public
var following_player:bool = false

# private

# signals

#--# VARS #--#



#### MAIN METHODS ####
func _ready():
	
	_on_orientation_changed()
	RSM.set_all_blend_positions(stats.orientation)


func _physics_process(delta):

	if following_player and PlayerInventory.player != null:
		
		if global_position.distance_to(PlayerInventory.player.global_position) <= PlayerInventory.NEAR:
			stats.path.clear()
		
		elif not stats.path.is_point_destination(PlayerInventory.player.global_position):
		
			if PlayerInventory.can_radio:
				stats.generate_path_to_destination(PlayerInventory.player.global_position, PlayerInventory.NEAR)
			
				if stats.path.empty():
					following_player = false

	# moves robo
	move(delta)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###

### updates ##
func follow_player():
	following_player = true
	stats.generate_path_to_destination(PlayerInventory.player.position, PlayerInventory.NEAR)


func move_to_mouse():
	following_player = false
	stats.generate_path_to_destination(get_global_mouse_position())

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###

### utils ###
func dir_towards_mosue() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()
	
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	var data := .to_data()
	
	# movement
	data.following_player = following_player
	
	# stats, upgrades and abilities
	
	# animation
	data.RSM = RSM.to_data()
	
	return data 


func from_data(data:Dictionary):
	
	.from_data(data)
	
	# movement
	if data.has("following_player"): following_player = data.following_player
	
	# stats, upgrades and abilities
	# animation
	if data.has("RSM"): RSM.from_data(data.RSM)
	
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_robo_change() -> void:
	remove_from_group(Groups.ROBO)


func on_node_is_ready(n:Node) -> void:
	if n.has_method(Groups.RoboWatcherFuncs.ON_ROBO_CHANGE):
		n.call(Groups.RoboWatcherFuncs.ON_ROBO_CHANGE, self)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_orientation_changed():
	
	if RSM == null:
		return
	
	if stats.orientation != Vector2.ZERO:
		RSM.set_all_blend_positions(stats.orientation)
	
	RSM.signal_event(RSM.Events.STOP_ROBO \
			if stats.orientation == Vector2.ZERO \
			else RSM.Events.MOVE_ROBO)


func _on_killed():
	RSM.signal_event(RSM.Events.KILL_ROBO)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#

