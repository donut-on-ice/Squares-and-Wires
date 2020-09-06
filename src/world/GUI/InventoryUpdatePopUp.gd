class_name InventoryUpdatePopUp extends HBoxContainer

#### VARS ####

# enums
enum IconTypes {
		NOT, AND, OR, XOR, OVER, UNDER,
		HEALTH, SPEED, DAMAGE, PROTECTION, UTILITY
	}

# consts
const IconTextures := {
		IconTypes.NOT: ComponentCounter.IconTextures[ComponentCounter.ComponentTypes.NOT],
		IconTypes.AND: ComponentCounter.IconTextures[ComponentCounter.ComponentTypes.AND],
		IconTypes.OR: ComponentCounter.IconTextures[ComponentCounter.ComponentTypes.OR],
		IconTypes.XOR: ComponentCounter.IconTextures[ComponentCounter.ComponentTypes.XOR],
		IconTypes.OVER: ComponentCounter.IconTextures[ComponentCounter.ComponentTypes.OVER],
		IconTypes.UNDER: ComponentCounter.IconTextures[ComponentCounter.ComponentTypes.UNDER],
		
		IconTypes.HEALTH: Upgrade.IconTextures[Upgrade.Types.HEALTH],
		IconTypes.SPEED: Upgrade.IconTextures[Upgrade.Types.SPEED],
		IconTypes.DAMAGE: Upgrade.IconTextures[Upgrade.Types.DAMAGE],
		IconTypes.PROTECTION: Upgrade.IconTextures[Upgrade.Types.PROTECTION],
		IconTypes.UTILITY: Upgrade.IconTextures[Upgrade.Types.UTILITY],
	}

# settings
# singletons

# nodes
onready var Nr:Number = $MarginConatiner/quantity/Number
onready var Icon:TextureRect = $Icon

# public
var type:int = IconTypes.NOT setget set_type
var quantity:int = 0 setget set_quantity
var time_limit:float = 5.0 # seconds

# private
var time_alive:float = 0.0

# signals

#--# VARS #--#



#### MAIN METHODS ####

func _process(delta):
	time_alive += delta
	if time_alive >= time_limit:
		queue_free()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_type(t:int):
	type = t
	Icon.set_texture(IconTextures[type])


func set_quantity(q:int):
	quantity = q
	Nr.set_number(quantity)

### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
static func pop_up_type_from_array_pos(i:int) -> int:
	
	match i:
		0: return IconTypes.NOT
		1: return IconTypes.AND
		2: return IconTypes.OR
		3: return IconTypes.XOR
		4: return IconTypes.OVER
		5: return IconTypes.UNDER
		
	return IconTypes.NOT



static func pop_up_type_from_upgrade_type(t:int) -> int:
	
	match t:
		Upgrade.Types.HEALTH: return IconTypes.HEALTH
		Upgrade.Types.SPEED: return IconTypes.SPEED
		Upgrade.Types.DAMAGE: return IconTypes.DAMAGE
		Upgrade.Types.PROTECTION: return IconTypes.PROTECTION
		Upgrade.Types.UTILITY: return IconTypes.UTILITY
	
	return IconTypes.UTILITY

### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
