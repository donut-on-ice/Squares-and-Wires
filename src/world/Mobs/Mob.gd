class_name Mob extends KinematicBody2D

#### VARS ####
# enums

# consts
const HURT_DEFORMATION := Color(1.0, 0.2, 0.2 ,1.0)
const HEAL_DEFORMATION := Color(0.2, 0.2, 1.0 ,1.0)
const BASE_MODULATION := Color.white

# settings
export(Resource) var initial_stats = MobStats.new()
export(Array, Resource) var abilities = []


# singletons
# nodes
# public
var stats:MobStats

# private
var hurt_time:float = 0.0
var heal_time:float = 0.0

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	stats = MobStats.new()
	
	if initial_stats != null and initial_stats is MobStats:
		stats.from_data(initial_stats.to_data())
	
	stats.parent = self
	stats.connect("killed", self, "_on_killed")
	_on_orientation_changed()
	stats.connect("orientation_changed", self, "_on_orientation_changed")


func _process(delta):
	
	for ab in abilities:
		ab.process(delta)


func _physics_process(delta):
	
	if hurt_time > 0.0:
		hurt_time = max(hurt_time - delta, 0.0)
		var e = ease(2*hurt_time, 5)
		modulate = BASE_MODULATION * (1 - e) + HURT_DEFORMATION * e
	
	if heal_time > 0.0:
		heal_time = max(heal_time - delta, 0.0)
		var e = ease(2*heal_time, 5)
		modulate = BASE_MODULATION * (1 - e) + HEAL_DEFORMATION * e
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
### updates ###
# returns if mob colided with static wall
func move(delta:float, acc_direction:Vector2 = Vector2.ZERO):
	
	if not stats.path.empty() and acc_direction != Vector2.ZERO:
		stats.path.clear()
	
	if acc_direction != Vector2.ZERO:
		stats.move_parent(delta, acc_direction)
	else:
		stats.move_parent_along_path(delta)
		


func apply_effect(ability:Ability, multiplier:int = 1) -> bool:
	
	match ability.type:
		Ability.Types.ATTACK: return hurt(ability as Attack, multiplier)
		Ability.Types.HEAL: return heal(ability as Heal, multiplier)
		Ability.Types.BLINK: pass
		Ability.Types.ACCELERATE: pass
		
	return false


func hurt(atk:Attack, multiplier:int = 1) -> bool:
	
	stats.health -= atk.damage - max(stats.armor - atk.penetration, 0) * multiplier
	heal_time = 0.0
	hurt_time = 0.5
	var e = ease(2*hurt_time, 5)
	modulate = BASE_MODULATION * (1 - e) + HURT_DEFORMATION * e
	
	return true


func heal(h:Heal, multiplier:int = 1) -> bool:
	stats.health += h.health * multiplier
	hurt_time = 0.0
	heal_time = 0.5
	var e = ease(2*heal_time, 5)
	modulate = BASE_MODULATION * (1 - e) + HURT_DEFORMATION * e
	return true

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
func to_data() -> Dictionary:
	
	var upgrades_data := []
	var abilities_data := []
	
	for ab in abilities:
		abilities_data.append(ab.to_data())
	
	return {
		# movement
		"position":			position,
	
		# stats, abilities and upgrades
		"stats":			stats.to_data(),
		"upgrades":			upgrades_data,
		"abilities":		abilities_data,
	}


func from_data(data:Dictionary):
	
	# movement 
	if data.has("position"): position = data.position
	
	# stats, abilities and upgrades
	if data.has("stats"): stats.from_data(data.stats)
	
	if data.has("abilities"):
		abilities.clear()
		for ab_data in data.abilities:
			abilities.append(Utils.ability_from_data(ab_data))


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
func _on_orientation_changed():
	pass


func _on_killed():
	pass

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
