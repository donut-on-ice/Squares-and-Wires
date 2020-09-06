tool
class_name Ability extends Resource

#### VARS ####
# enums
enum Types {NONE, BLINK, ATTACK, HEAL, ACCELERATE}

# consts
# settings
# singletons
# nodes
# public
var type:int = Types.NONE
export(float) var cooldown:float = 0.0
export(float) var active_cooldown:float = 0.0
export(float) var tick_time = 0.0

export(bool) var targeted:bool = false
export(bool) var one_shot:bool = false
export(bool) var always_on:bool = false


# private
var cooldown_time:float = 0.0
var active_cooldown_time:float = 0.0
var time_since_last_tick:float = 0.0

# signals
signal ticked
signal cooleddown
signal deactivated
 
#--# VARS #--#



#### MAIN METHODS ####

func process(delta:float):
	
	if always_on:
		return
	
	if cooldown_time > 0.0:
		cooldown_time = max(cooldown_time - delta, 0.0)
		if cooldown_time <= 0.0:
			emit_signal("cooleddown")
	
	
	if active_cooldown_time > 0.0:
		
		var adjusted_delta = min(active_cooldown_time, delta)
		
		time_since_last_tick += adjusted_delta
		
		if tick_time >= 0.0:
			emit_signal("ticked", floor(time_since_last_tick/tick_time))
			time_since_last_tick = fmod(time_since_last_tick, tick_time)
		
		active_cooldown_time -= adjusted_delta
		if active_cooldown_time <= 0.0:
			emit_signal("deactivated")
			time_since_last_tick = 0.0
		
		

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func start_cooldown():
	if not always_on:
		cooldown_time = cooldown


func start_active_cooldown():
	if not always_on and not one_shot:
		active_cooldown_time = active_cooldown
	start_cooldown()



### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###

### bools ###
func is_activable() -> bool:
	return cooldown > 0.0 and cooldown_time <= 0.0 and not always_on


func is_active() -> bool:
	return active_cooldown == 0.0 or active_cooldown_time > 0.0 or always_on

### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
func to_data() -> Dictionary:
	return {
		"type": type,
		"cooldown": cooldown,
		"cooldown_time": cooldown_time,
		"active_cooldown": active_cooldown,
		"active_cooldown_time": active_cooldown_time,
		"tick_time": tick_time,
		"time_since_last_tick": time_since_last_tick,
		"targeted": targeted,
		"one_shot": one_shot,
		"always_on": always_on
	}


func form_data(data:Dictionary):
	type = data.type if data.has("type") else Types.NONE
	cooldown = data.cooldown if data.has("cooldown") else 0.0
	cooldown_time = data.cooldown_time if data.has("cooldown_time") else 0.0
	active_cooldown = data.active_cooldown if data.has("active_cooldown") else 0.0
	active_cooldown_time = data.active_cooldown_time if data.has("active_cooldown_time") else 0.0
	tick_time = data.tick_time if data.has("tick_time") else 0.0
	tick_time = data.time_since_last_tick if data.has("time_since_last_tick") else 0.0
	targeted = data.targeted if data.has("targeted") else false
	one_shot = data.one_shot if data.has("one_shot") else false
	always_on = data.always_on if data.has("always_on") else false
	
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
