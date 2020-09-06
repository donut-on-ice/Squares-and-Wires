class_name MobStats extends Resource

#### VARS ####
# enums
enum MobTypes {NONE, CATERPILLAR, BEETALO, PLAYER, ROBO}

# consts
# settings
export(int) var max_health:int = 0 setget set_max_health
export(int) var health:int = 0 setget set_health
export(int) var armor:int = 0

export(float) var acceleration:float = 0.0
export(float) var max_speed:float = 0.0
export(float) var mass:float = 10.0
export(Vector2) var orientation:Vector2 = Vector2(0, 1)
export(float) var near_zero:float = 5.0

export(int) var sight_range:int = 0
export(MobTypes) var mob_type:int = MobTypes.NONE

# singletons
# nodes
var parent:KinematicBody2D

# public
var speed := Vector2(0.0, 0.0)

# private
var path := AutoWalkPath.new(near_zero)

# signals
signal killed
signal orientation_changed

#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_health(hp:int):
	hp = min(max_health, max(0, hp))

	if health > 0 and hp == 0:
		emit_signal("killed")

	health = hp


func set_max_health(m_hp:int):
	max_health = m_hp
	if health > max_health:
		set_health(max_health)


### updates ###
func simple_path_to_destination(destination:Vector2, near_destination:float = 0.0):
	path.NEAR_DESTINATION = max(near_destination, path.NEAR_ZERO)
	path.simple_path(parent.position, destination)


func generate_path_to_destination(destination:Vector2, near_destination:float = 0.0):
	path.NEAR_DESTINATION = max(near_destination, path.NEAR_ZERO)
	path.from_nav2d(parent.position, destination)


func empty_path():
	path.clear()


func move_parent_along_path(delta:float) -> bool:
	return move_parent(delta, path.acceleration_from(parent.position))


func move_parent(delta:float, acc_direction:Vector2):
	speed += acc_direction * 2 * acceleration * delta
	speed -= (speed.normalized() * acceleration * delta).clamped(speed.length())
	speed = parent.move_and_slide(speed.clamped(max_speed))
	orientation = acc_direction
	emit_signal("orientation_changed")
	
	if path.empty():
		return 
	
	for i in parent.get_slide_count():
		var collision:KinematicCollision2D = parent.get_slide_collision(i)
		
		var c = collision.collider
		
		if c.collision_layer & Utils.CollisionLayers.STATIC_BLOCKS_PATH \
				and abs(acc_direction.angle_to(collision.normal)) > PI/3:
			path.clear()
			break


func add(st): #MobStats
	
	max_health += st.max_health
	health += st.health
	
	max_speed += st.max_speed
	mass += st.mass
	acceleration += st.acceleration
	
	sight_range += st.sight_range


func sub(st): #MobStats
	
	st.health = max(0, st.max_health - (max_health - health))
	
	max_health -= st.max_health
	health -= st.health
	set_health(health)
	
	max_speed -= st.max_speed
	mass -= st.mass
	acceleration -= st.acceleration
	speed.clamped(max_speed)
	
	
	sight_range -= st.sight_range

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	return {
		
		# health
		"max_hp": max_health,
		"armor": armor,
		"hp": health,
		
		# movement
		"max_speed": max_speed,
		"acc": acceleration,
		"speed": speed,
		"mass": mass,
		"path": path.to_data(),
		
		# misc
		"sight_range": sight_range,
	}


func from_data(data:Dictionary):
	# health
	max_health = data.max_hp if data.has("max_hp") else 0
	armor = data.armor if data.has("armor") else 0
	health = data.hp if data.has("hp") else 0
	
	# movement
	acceleration = data.acc if data.has("acc") else 0.0
	max_speed = data.max_speed if data.has("max_speed") else 0.0
	speed = data.speed if data.has("speed") else 0.0
	mass = data.mass if data.has("mass") else 0.0
	path = AutoWalkPath.new()
	if data.has("path"): 
		path.from_data(data.path)
	
	# misc
	sight_range = data.sight_range if data.has("sight_range") else 0

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
