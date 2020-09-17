extends Node

#### VARS ####
# enums
enum Presets {
		EMPTY,
		FIVE_OF_ALL,
		TEN_OF_ALL,
		START
	}

# consts
const HALF_CELL_LENGTH := 16
const NEAR := 2 * HALF_CELL_LENGTH

const cc := {
		Presets.EMPTY: [0, 0, 0, 0, 0, 0],
		Presets.FIVE_OF_ALL: [5, 5, 5, 5, 5, 5],
		Presets.TEN_OF_ALL: [10, 10, 10, 10, 10, 10],
		Presets.START: [5, 5, 5, 5, 5, 5]
	}

# settings
# singletons
# nodes
var player
var robo

# public
var can_radio:bool = false setget set_can_radio

# private

# [not_gates, and_gates, or_gates, xor_gates, bridge_over, bridge_under]
var component_counts:Array = [0, 0, 0, 0, 0, 0] setget set_component_counts
var upgrades := []
var player_upgrades := []
var robo_upgrades := []

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	add_to_group(Groups.SAVABLES)


func _physics_process(_delta:float):
	
	if robo != null and player != null:
		var radio_range:float = min(player.radio_range, robo.radio_range) * HALF_CELL_LENGTH
		if player.position.distance_to(robo.position) < radio_range != can_radio:
			set_can_radio(not can_radio)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_component_counts_from_preset(preset:int):
	set_component_counts(cc[preset if cc.has(preset) else Presets.EMPTY])


func set_component_counts(a:Array):
	
	component_counts = a
	
	update_component_counts_watcehrs()


func increment_compoennt_count(i:int):
	
	if not can_increment_compoennt_count(i):
		return
	component_counts[i] += 1
	
	update_component_counts_watcehrs()


func decrement_compoenent_count(i:int):
	
	if not can_decrement_compoennt_count(i):
		return
		
	component_counts[i] -= 1
	
	update_component_counts_watcehrs()


func add_to_inventory(components:Array, ups:Array):
	
	for i in range(component_counts.size()):
		component_counts[i] += components[i]
		
	for up in ups:
		upgrades.append(up)

	update_component_counts_watcehrs()
	get_tree().call_group(Groups.PLAYER_INVENTORY_WATCHERS,
			Groups.PlayerInventoryWatcherFuncs.ON_ADDITION,
			components, ups)
	
	if not ups.empty():
		update_upgrades_watchers()


func set_can_radio(b:bool):
	can_radio = b
	if robo != null and player != null:
		get_tree().call_group(Groups.PLAYER_INVENTORY_WATCHERS,
				Groups.PlayerInventoryWatcherFuncs.ON_CAN_RADIO_CHANGE)	


func reset_inventory():
	set_component_counts_from_preset(Presets.EMPTY)
	player_upgrades.clear()
	upgrades.clear()
	robo_upgrades.clear()

### updates ###
func update_component_counts_watcehrs():
	get_tree().call_group(Groups.PLAYER_INVENTORY_WATCHERS,
			Groups.PlayerInventoryWatcherFuncs.ON_COMPONENT_COUNTS_CHANGE)


func update_mob_stats_watchers():
	if robo != null and player != null:
		get_tree().call_group(Groups.PLAYER_INVENTORY_WATCHERS,
				Groups.PlayerInventoryWatcherFuncs.ON_MOB_STATS_CHANGE)


func update_upgrades_watchers():
	get_tree().call_group(Groups.PLAYER_INVENTORY_WATCHERS,
			Groups.PlayerInventoryWatcherFuncs.ON_UPGRADES_CHANGE)


func update_upgrade(up:Upgrade):
	
	if up == null:
		return
	
	if player_upgrades.has(up):
		player.update_stats()
		update_mob_stats_watchers()
	if robo_upgrades.has(up):
		robo.update_stats()
		update_mob_stats_watchers()


func sub_upgrade(up:Upgrade):
	
	if player_upgrades.has(up):
		player.stats.sub(up.get_current_stats())
		update_mob_stats_watchers()
	
	if robo_upgrades.has(up):
		robo.stats.sub(up.get_current_stats())
		update_mob_stats_watchers()


func add_upgrade(up:Upgrade):
	
	if player_upgrades.has(up):
		player.stats.add(up.get_current_stats())
		update_mob_stats_watchers()
	
	if robo_upgrades.has(up):
		robo.stats.add(up.get_current_stats())
		update_mob_stats_watchers()


func gui_place_player_upgrade(up:Upgrade, index:int):
	
	if up == null:
		return
	
	if index > player_upgrades.size():
		player_upgrades.append(up)
	else:
		player_upgrades.insert(index, up)
	
	player.stats.sub(up.get_current_stats())
	
	update_mob_stats_watchers()
	update_upgrades_watchers()


func gui_place_upgrade(up:Upgrade, index:int):
	
	if up == null:
		return
	
	if index > upgrades.size():
		upgrades.append(up)
	else:
		upgrades.insert(index, up)
		
	update_upgrades_watchers()


func gui_place_robo_upgrade(up:Upgrade, index:int):
	
	if up == null:
		return
	
	if index > robo_upgrades.size():
		robo_upgrades.append(up)
	else:
		robo_upgrades.insert(index, up)
	
	robo.stats.sub(up.get_current_stats())
	
	update_mob_stats_watchers()
	update_upgrades_watchers()

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_upgradable_upgrades() -> Array:
	
	var upgradables := []
	var currently_accepted_up_levels:Array = LevelManager.get_currently_accepted_up_levels()
	
	for up in player_upgrades + upgrades + robo_upgrades:
		if not up.upgraded_this_level and currently_accepted_up_levels.has(up.level):
			upgradables.append(up)
	
	upgradables.shuffle()
	
	return upgradables


### bools ###
func empty() -> bool:
	return player_upgrades.empty() and upgrades.empty() and robo_upgrades.empty()


func can_increment_compoennt_count(i:int) -> bool:
	return  0 <= i and i < component_counts.size()


func can_decrement_compoennt_count(i:int) -> bool:
	return  0 <= i and i < component_counts.size() \
			and component_counts[i] > 0

### utils ###

#--# NON STATE CHANGING METHODS #--#


#### DATA METHODS ####

func get_unique_name() -> String:
	return name


func to_data() -> Dictionary:
	
	var ups_data := []
	var player_ups_data := []
	var robo_ups_data := []
	
	for up in upgrades:
		ups_data.append(up.to_data())
	
	for up_player in player_upgrades:
		player_ups_data.append(up_player.to_data())
	
	for up_robo in robo_upgrades:
		robo_ups_data.append(up_robo.to_data())
		
	
	return {
			"component_counts": component_counts,
			"upgrades": ups_data,
			"player_upgrades": player_ups_data,
			"robo_upgrades": robo_ups_data
		}


func from_data(data:Dictionary):
	
	if data.has("component_counts"):
		set_component_counts(data.component_counts)
		update_component_counts_watcehrs()

	upgrades.clear()
	player_upgrades.clear()
	robo_upgrades.clear()

	if data.has("upgrades"):
		for up_data in data.upgrades:
			var up := Upgrade.new()
			up.from_data(up_data)
			upgrades.append(up)
		upgrades.sort_custom(Upgrade, "compare_by_type_then_level")

	if data.has("player_upgrades"):
		for up_data in data.player_upgrades:
			var up := Upgrade.new()
			up.from_data(up_data)
			player_upgrades.append(up)
	
	if data.has("robo_upgrades"):
		for up_data in data.robo_upgrades:
			var up := Upgrade.new()
			up.from_data(up_data)
			robo_upgrades.append(up)

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
