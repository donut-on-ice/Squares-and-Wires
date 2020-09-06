class_name HitArea extends AreaWithTargets

#### VARS ####
# enums
# consts
# settings
export(Resource) var ability setget set_ability

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():

	if not is_connected("target_entered", self, "_on_target_entered"):
		connect("target_entered", self, "_on_target_entered")

	set_ability(ability)


func _process(delta):
	
	if ability == null:
		return
	
	ability.process(delta)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###

func set_ability(a:Ability):
	
	if ability != null:
	
		if ability.cooldown_time > 0.0:
			ability.disconnect("cooleddown", self, "prime")
	
		if ability.active_cooldown_time > 0.0:
			ability.disconnect("deactivated", self, "stop")
	
		if not ability.one_shot and ability.tick_time > 0.0:
			
			if ability.targeted:
				ability.disconnect("ticked", self, "hit_all")
				
			else:
				ability.disconnect("ticked", self, "hit_target")
	
	ability = a

	if ability != null:

		if ability.cooldown_time > 0.0:
			ability.connect("cooleddown", self, "prime_for_hitting")
	
		if ability.active_cooldown_time > 0.0:
			ability.connect("deactivated", self, "stop_hitting")
	
		if not ability.one_shot and ability.tick_time > 0.0:
			
			if ability.targeted:
				ability.connect("ticked", self, "hit_all")
				
			else:
				ability.connect("ticked", self, "hit_target")


### updates ###
func start_hit():
	
	if ability.targeted:
		hit_target()
	else:
		hit_all()
	
	if ability.one_shot:
		ability.start_cooldown()
	else:
		ability.start_active_cooldown()


func prime_for_hitting():
	
	for c in get_children():
		if "disabled" in c:
			c.disabled = false
	
	monitorable = true
	monitoring = true


func stop_hitting():
	
	ability.start_cooldown()
	
	Targets.clear()
	
	for c in get_children():
		if "disabled" in c:
			c.disabled = true
	
	monitorable = false
	monitoring = false


func hit_target(multiplier:int = 1):
	
	if MainTargetArea == null:
		return
		
	MainTargetArea.target.apply_effect(ability, multiplier)


func hit_all(multiplier:int = 1):
	for t in Targets.keys():
		
		t.apply_effect(ability, multiplier)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_target_entered(target):
	
	if ability.is_active() and not ability.targeted:
		target.apply_effect(ability)
	
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
