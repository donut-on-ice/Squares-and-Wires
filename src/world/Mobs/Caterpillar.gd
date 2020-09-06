class_name Caterpillar extends Mob

#### VARS ####
# enums
# consts
const MiddleSectionPacked := preload("res://Scenes/Mobs/CaterpillarSection.tscn")
const Splash := preload("res://Scenes/Mobs/CaterpillarSplash.tscn")
const in_world_size := 3

# settings
export(float) var space_delay := 2 # pixels
export(int) var sections_nr := 2 

# singletons
# nodes
onready var AT:AnimationTree = $AnimationTree
onready var AutoAttack := $HitArea
onready var Agro := $Agro
onready var Fear := $Fear
onready var sections := [$HurtAreaHead]
onready var sections_positions := []

# public
onready var idle_center:Vector2 = global_position
var following_player:bool = false
var runing_from_danger:bool = false
var is_idle:bool = false
var time_til_idle_move:float = 0.0

# signals
#--# VARS #--#



#### MAIN METHODS ####
func _ready():
	
	if not Agro.is_connected("target_entered", self, "_on_Agro_target_entered"):
		Agro.connect("target_entered", self, "_on_Agro_target_entered")

	if not Agro.is_connected("target_exited", self, "_on_Agro_target_exited"):
		Agro.connect("target_exited", self, "_on_Agro_target_exited")

	if not Fear.is_connected("target_entered", self, "_on_Fear_target_entered"):
		Fear.connect("target_entered", self, "_on_Fear_target_entered")

	if not Fear.is_connected("target_exited", self, "_on_Fear_target_exited"):
		Fear.connect("target_exited", self, "_on_Fear_target_exited")
		
	if not AutoAttack.is_connected("target_entered", self, "_on_Attack_target_entered"):
		AutoAttack.connect("target_entered", self, "_on_Attack_target_entered")
	
	_on_orientation_changed()
	sections_positions.append(sections[0].global_position)
	for i in range(sections_nr):
		var section := MiddleSectionPacked.instance()
		section.name = "HurtAreaSection " + String(i)
		add_child_below_node(sections[i], section)
		sections.append(section)
		sections_positions.append(sections[i + 1].global_position)
	


func _physics_process(delta):
	
	if runing_from_danger and not Fear.Targets.empty():

		var fear_realtive_center := Vector2.ZERO
		var weight_sum := 0.0
		
		for f in Fear.Targets.keys():
		
			var weight := 1.0 / global_position.distance_to(f.global_position)
			weight_sum += weight
			fear_realtive_center += (f.global_position - global_position) * weight

		fear_realtive_center /= weight_sum
		
		if not stats.path.is_point_destination(PlayerInventory.player.global_position):
			stats.simple_path_to_destination(global_position - 2*fear_realtive_center, in_world_size)
	
			if stats.path.empty():
				runing_from_danger = false
	
	elif following_player and PlayerInventory.player != null:
		
		if not stats.path.is_point_destination(PlayerInventory.player.global_position):
		
			stats.simple_path_to_destination(PlayerInventory.player.global_position, in_world_size)
		
			if stats.path.empty():
				following_player = false
	
	
	if AutoAttack.ability.is_activable() and AutoAttack.Targets.has(PlayerInventory.player):
		attack()
		
	move(delta)
	
	if not runing_from_danger and not following_player:
		if stats.path.empty() and not is_idle:
			idle_center = global_position
			is_idle = true
	else:
		is_idle = false
	
	if is_idle:
		time_til_idle_move = max(0.0, time_til_idle_move - delta)
		if time_til_idle_move <= 0.0:
			stats.simple_path_to_destination(idle_center + Vector2(
				(2 * randf() - 1) * 16,
				(2 * randf() - 1) * 16
			), in_world_size)
			time_til_idle_move = rand_range(3.0, 7.0)
	
	sections_positions[0] = sections[0].global_position
	for i in range(1, sections.size()):
		var dif:Vector2 = sections_positions[i] - sections_positions[i - 1]
		if dif.length() > space_delay:
			sections_positions[i] = sections_positions[i - 1] + dif.normalized() * space_delay 
		sections[i].global_position = sections_positions[i]
		 
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###

### updates ###
func target_player():
	if AutoAttack.Targets.has(PlayerInventory.player) \
			and not AutoAttack.Targets[PlayerInventory.player].empty():
		AutoAttack.Targets[PlayerInventory.player].sort_custom(self, "sort_nodes_by_distance")
		AutoAttack.MainTargetArea = AutoAttack.Targets[PlayerInventory.player].front()


func attack():
	AutoAttack.start_hit()


func move_sections():
	
	if sections_nr <= 0:
		return
	
	for s in sections:
		s.position -= 00000

### utils ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###

### utils ###
func sort_nodes_by_distance(A:Node, B:Node) -> bool:
	return global_position.distance_to(A.global_position) < global_position.distance_to(B.global_position)

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	var data := .to_data()
	
	data.sections_positions = sections_positions
	data.following_player = following_player
	data.runing_from_danger = runing_from_danger
	data.is_idle = is_idle
	data.time_til_idle_move = time_til_idle_move
	
	return data

func from_data(data:Dictionary):
	.from_data(data)
	
	if data.has(data.sections_positions):
		sections_positions = data.sections_positions
		for i in range(sections.size()):
			sections[i].global_position = sections_positions[i]
	
	following_player = data.following_player if data.has(data.sections_positions) else false
	runing_from_danger = data.runing_from_danger if data.has(data.runing_from_danger) else false
	is_idle = data.is_idle if data.has(data.is_idle) else false
	time_til_idle_move = data.time_til_idle_move if data.has(data.time_til_idle_move) else 0.0

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
func _on_Agro_target_entered(_target:Mob):
	if not Agro.Targets.empty():
		following_player = true


func _on_Agro_target_exited(_target:Mob):
	if Agro.Targets.empty():
		following_player = false


func _on_Fear_target_entered(_target:Mob):
	if not Agro.Targets.empty():
		runing_from_danger = true


func _on_Fear_target_exited(_target:Mob):
	if Agro.Targets.empty():
		runing_from_danger = false


func _on_Attack_target_entered(_target:Mob):
	if AutoAttack.Targets.has(PlayerInventory.player):
		target_player()


func _on_orientation_changed():
	if AT != null:
		if stats.orientation != Vector2.ZERO:
			AT.set("parameters/blend_position", stats.orientation)


func _on_killed():
	var splash:AnimatedSprite = Splash.instance()
	splash.global_position = global_position
	splash.play()
	get_parent().add_child_below_node(self, splash)
	queue_free()

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
