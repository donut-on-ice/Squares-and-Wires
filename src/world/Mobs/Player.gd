class_name Player extends Mob

#### VARS ####

# enums
# consts
const in_world_size := 12
const eye_pos := Vector2(0, -6)
const textures := {
	NORMAL = preload("res://assets/mobs/Player/Player_Body_Sheet.png"),
	HOVERED = preload("res://assets/mobs/Player/Player_Body_Highlighted_Sheet.png")
}

# settings
export(NodePath) var fog_path:String = "../../../../Fog"
export(int) var radio_range := 5

# singletons
# nodes
onready var fog:Fog = get_node(fog_path)
onready var PSM:PlayerStateMachine = $AnimationTree
onready var body_sprite:Sprite = $Body
onready var Cam:Camera2D = $Camera

# public
var target:Node2D

# private
onready var old_pos_in_fog:Vector2
var perfect_circle:PoolVector2Array
var hovered := false setget set_hovered

# signals

#--# VARS #--#



#### MAIN METHODS ####
func _ready():
	_on_orientation_changed()
	add_to_group(Groups.MOUSE_WATCHERS)
	on_mouse_tool_change()
	
	PSM.set_all_blend_positions(stats.orientation)
	add_to_group(Groups.PLAYER_VISION)
	perfect_circle = Utils.pixel_perfect_cicle(Vector2.ZERO, stats.sight_range)
	

# in each frame the game: 
#		- moves player
#		- unfogs 1 square of fog per collision ray
func _physics_process(delta:float):	
	
	# moves player
	move(delta, movement_input_to_vector2())
	
	if target != null:
		var pos = target.get_target_global_position() \
				if target.has_method("get_target_global_position") \
				else target.global_position
		
		var target_half_size:float = target.in_world_size/2 if "in_world_size" in target else 0.0
		
		if pos.distance_to(get_body_global_position()) < (PlayerInventory.NEAR + target_half_size):
			if target.has_method("activate"):
				target.activate()
				target = null
				stats.path.clear()
		elif stats.path.empty():
			target = null
	
	# unfogs 1 square of fog per collision ray
	unfog()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_hovered(h:bool):
	hovered = h
	update_texture()


### updates ###
func unfog():
	var new_pos_in_fog = fog.world_to_map(global_position + eye_pos)
	
	if old_pos_in_fog != new_pos_in_fog:
		old_pos_in_fog = new_pos_in_fog
		
		# unfogs 1 square of fog per collision ray
		for y in range(new_pos_in_fog.y - stats.sight_range, new_pos_in_fog.y + stats.sight_range + 1):
			for x in range(new_pos_in_fog.x - stats.sight_range, new_pos_in_fog.x + stats.sight_range + 1):
				
				var cell_pos := Vector2(x, y)
				
				if fog.get_cell(x, y) == TileMap.INVALID_CELL:
					continue
				
				if stats.sight_range * stats.sight_range - (new_pos_in_fog - cell_pos).length_squared() < Utils.ZERO:
					continue
					
				var origin:Vector2 = new_pos_in_fog * fog.cell_size
				var destination:Vector2 = cell_pos * fog.cell_size
				
				var collision := get_world_2d().direct_space_state.intersect_ray(
						origin, destination, [],
						Utils.CollisionLayers.BLOCKS_SIGHT | Utils.CollisionLayers.STATIC_BLOCKS_SIGHT)
			
				cell_pos = fog.world_to_map(collision.position) \
						if !collision.empty() \
						else cell_pos
				
				fog.set_cellv(cell_pos, fog.Tiles.EMPTY)
		
				if !collision.empty():
					cell_pos -= collision.normal
					fog.set_cellv(cell_pos, fog.Tiles.EMPTY)
		
		var start:Vector2 = new_pos_in_fog - stats.sight_range * Vector2.ONE
		var end:Vector2 = new_pos_in_fog + (stats.sight_range + 1) * Vector2.ONE
		fog.update_bitmask_region(start, end)


func update_texture():
	body_sprite.texture = textures.HOVERED \
		if is_highlighted() \
		else textures.NORMAL


func is_highlighted() -> bool:
	return hovered and Mouse.mouse_tool == Mouse.Tools.RADIO and stats.health > 0


func move_to_mouse():
	stats.generate_path_to_destination(get_global_mouse_position())


func move_to_target(obj:Node2D):
	target = obj
	var pos = target.get_target_global_position() \
			if target.has_method("get_target_global_position") \
			else target.global_position
	stats.generate_path_to_destination(pos, PlayerInventory.NEAR / 3 * 2)


func hurt(atk:Attack, multiplier:int = 1) -> bool:
	
	if SceneManager.view_case != SceneManager.Cases.MAP:
		SceneManager.view_case = SceneManager.Cases.MAP
	
	Cam.shake(atk.damage)
	
	return .hurt(atk, multiplier)
	

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_body_global_position() -> Vector2:
	return body_sprite.global_position

### bools ###

### utils ###
func movement_input_to_vector2() -> Vector2:
	return Vector2.ZERO \
		if SceneManager.view_case != SceneManager.Cases.MAP \
		else Vector2(
				Input.get_action_strength("player_est") - Input.get_action_strength("player_west"),
				Input.get_action_strength("player_south") - Input.get_action_strength("player_north")
			).normalized()


func direction_towards_mosue() -> Vector2:
	return (get_global_mouse_position() - global_position).normalized()

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	
	# movement
	# stats, abilities and upgrades
	var data := .to_data()
	
	# vision
	data.old_pos_in_fog = old_pos_in_fog
	
	# animation
	data.PSM = PSM.to_data()
	
	return data


func from_data(data:Dictionary):

	# movement 
	# stats, abilities and upgrades
	.from_data(data)
	
	# vision
	if data.has("old_pos_in_fog"): old_pos_in_fog = data.old_pos_in_fog
	
	# animation
	if data.has("PSM"): PSM.from_data(data.PSM)

#--# DATA METHODS #--#



#### GROUP METHODS ####

# MouseWatcherFuncs
func on_mouse_tool_change():
	update_texture()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_orientation_changed():
	
	if PSM == null:
		return
	
	if stats.orientation != Vector2.ZERO:
		PSM.set_all_blend_positions(stats.orientation)
	
	PSM.signal_event(PSM.Events.STOP_PLAYER \
			if stats.orientation == Vector2.ZERO \
			else PSM.Events.MOVE_PLAYER)


func _on_killed():
	update_texture()
	PSM.signal_event(PSM.Events.KILL_PLAYER)


func _on_dead():
	get_tree().call_group(Groups.MASTER_NODE, Groups.MasterNodeFuncs.GAME_LOST)


func _on_ClickArea_mouse_entered():
	set_hovered(true)


func _on_ClickArea_mouse_exited():
	set_hovered(false)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
