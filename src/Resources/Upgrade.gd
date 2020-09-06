class_name Upgrade extends Resource

#### VARS ####

# enums
enum Types {HEALTH, SPEED, DAMAGE, PROTECTION, UTILITY, NONE}

# consts
const IconTextures := {
		Types.HEALTH: preload("res://assets/ui/inventory/health_upgrade_icon.png"),
		Types.SPEED: preload("res://assets/ui/inventory/speed_upgrade_icon.png"),
		Types.DAMAGE: preload("res://assets/ui/inventory/damage_upgrade_icon.png"),
		Types.PROTECTION: preload("res://assets/ui/inventory/protection_upgrade_icon.png"),
		Types.UTILITY: preload("res://assets/ui/inventory/utility_upgrade_icon.png"),
		Types.NONE: null
	}

# settings
# singletons
# nodes
# public
var type:int = Types.NONE
export(int, 4) var level := 0
export(String) var title:String = ""
export(String) var question:String = ""
export(String) var right_answer:String = ""
export(bool) var upgraded_this_level = false
export(PoolStringArray) var wrong_answers:PoolStringArray = PoolStringArray([])
var stats_array := [
		MobStats.new(),
		MobStats.new(),
		MobStats.new(),
		MobStats.new(),
		MobStats.new()
	]

# private
# signals

#--# VARS #--#



#### MAIN METHODS ####

func validate():
	pass

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
func get_current_stats() -> MobStats:
	return stats_array[level]


func get_texture() -> Texture:
	return IconTextures[type]


### bools ###

### utils ###
static func compare_by_type_then_level(a:Upgrade, b:Upgrade) -> bool:
	return a.type < b.type if a.type != b.type else a.level < b.level


static func compare_by_level_then_type(a:Upgrade, b:Upgrade) -> bool:
	return a.level < b.level if a.level != b.level else a.type < b.type

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
func to_data() -> Dictionary:
	
	var stats_array_data = []
	
	for s in stats_array:
		stats_array_data.append(s.to_data())
	
	return {
		"type": type,
		"level": level,
		"title": title,
		"question": question,
		"right_answer": right_answer,
		"wrong_answers": wrong_answers,
		"stats_array": stats_array_data,
		"upgraded_this_level": upgraded_this_level
	}


func from_data(data:Dictionary): 
	type = data.type if data.has("type") else Types.NONE
	level = data.level if data.has("level") else 0
	title = data.title if data.has("title") else ""
	question = data.question if data.has("question") else ""
	right_answer = data.right_answer if data.has("right_answer") else ""
	wrong_answers = data.wrong_answers if data.has("wrong_answers") else PoolStringArray([])
	upgraded_this_level = data.upgraded_this_level if data.has("upgraded_this_level") else false
	if data.has("stats_array_data"):
		for i in range(stats_array.size()):
			stats_array[i].from_data(data.stats_array_data[i])


func bonus_to_str() -> String:
	return ""

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
