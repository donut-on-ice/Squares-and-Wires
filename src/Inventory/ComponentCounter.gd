tool
class_name ComponentCounter extends VBoxContainer

#### VARS ####
# enums
enum ComponentTypes {NOT, AND, OR, XOR, OVER, UNDER,}

# consts
const IconTextures := {
		ComponentTypes.NOT: preload("res://assets/ui/inventory/not_icon.png"),
		ComponentTypes.AND: preload("res://assets/ui/inventory/and_icon.png"),
		ComponentTypes.OR: preload("res://assets/ui/inventory/or_icon.png"),
		ComponentTypes.XOR: preload("res://assets/ui/inventory/xor_icon.png"),
		ComponentTypes.OVER: preload("res://assets/ui/inventory/over_icon.png"),
		ComponentTypes.UNDER: preload("res://assets/ui/inventory/under_icon.png")
	}

const IconHints := {
		ComponentTypes.NOT: "NOT logic gate",
		ComponentTypes.AND: "AND logic gate",
		ComponentTypes.OR: "OR logic gate",
		ComponentTypes.XOR: "XOR logic gate",
		ComponentTypes.OVER: "OVER board wire bridge",
		ComponentTypes.UNDER: "UNDER board wire bridge"
	}

# settings
export(ComponentTypes) var type = ComponentTypes.NOT setget set_type

# singletons
# nodes
onready var Counter:Number = $Nr
onready var Icon:TextureRect = $IconBackgroud/Icon

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	if not Engine.editor_hint:
		add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	
	update_number()
	update_icon()
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_type(i:int) -> void:
	type = i
	update_icon()


### updates ###
func update_icon() -> void:
	if !is_inside_tree():
		return
	
	Icon.texture = IconTextures[type]
	Icon.hint_tooltip = IconHints[type]


func update_number() -> void:
	if !is_inside_tree():
		return
	
	Counter.set_number(PlayerInventory.component_counts[type])


#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_component_counts_change() -> void:
	update_number()

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
