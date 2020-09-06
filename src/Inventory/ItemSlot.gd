class_name ItemSlot extends TextureRect

#### VARS ####
# enums
enum SlotTypes {PLAYER_EQUIP, INVENTORY, ROBO_EQUIP}

# consts
const IconTextures := {
		Upgrade.Types.HEALTH: preload("res://assets/ui/inventory/health_upgrade_icon.png"),
		Upgrade.Types.SPEED: preload("res://assets/ui/inventory/speed_upgrade_icon.png"),
		Upgrade.Types.DAMAGE: preload("res://assets/ui/inventory/damage_upgrade_icon.png"),
		Upgrade.Types.PROTECTION: preload("res://assets/ui/inventory/protection_upgrade_icon.png"),
		Upgrade.Types.UTILITY: preload("res://assets/ui/inventory/utility_upgrade_icon.png"),
		Upgrade.Types.NONE: null
	}

# settings
export(SlotTypes) var slot_type:int = SlotTypes.INVENTORY
export(Upgrade.Types) var upgrade_type:int = Upgrade.Types.NONE setget set_upgrade_type
export(int) var index:int = 0

# singletons
# nodes
onready var Highlight:TextureRect = $PickableBg/Hovered
onready var Item:TextureRect = $PickableBg/ItemIcon
var InventoryGui:Control

# public
# private
onready var true_rect2 := Rect2(Item.get_global_position(), 
		Item.rect_size * Utils.get_control_true_scale(Item))

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _input(event:InputEvent):

	if event is InputEventMouseMotion:
		
		if not has_point(event.position):
		
			Highlight.visible = false
		
		elif not Highlight.visible:
		
			Highlight.visible = InventoryGui.can_pick(slot_type, index) \
				or InventoryGui.can_place_here(slot_type) \
				if InventoryGui != null \
				else false
	
	if event is InputEventMouseButton \
			and event.button_index == BUTTON_LEFT \
			and has_point(event.position):
		if Input.is_action_just_pressed("set"):
			InventoryGui.pick(slot_type, index, get_global_mouse_position() - get_global_position())
			accept_event()
		elif Input.is_action_just_released("set"):
			InventoryGui.place_here(slot_type, index)
			accept_event()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_upgrade_type(ut:int):
	upgrade_type = ut
	Item.visible = upgrade_type != Upgrade.Types.NONE
	Item.set_texture(IconTextures[upgrade_type])

### updates ###
func update(scroll_padding:int = 0):
	
	upgrade_type = Upgrade.Types.NONE
	hint_tooltip = ""
	
	var from := []
	
	match slot_type:
		SlotTypes.PLAYER_EQUIP:
			from = PlayerInventory.player_upgrades
		SlotTypes.INVENTORY:
			from = PlayerInventory.upgrades
		SlotTypes.ROBO_EQUIP:
			from = PlayerInventory.robo_upgrades
	
	if from.size() > index + scroll_padding:
		var up:Upgrade = from[index]
		upgrade_type = up.type
		hint_tooltip += up.title + '\n'
		hint_tooltip += "level: " + String(up.level) + "\n"
		hint_tooltip += up.bonus_to_str()
	
	Item.visible = upgrade_type != Upgrade.Types.NONE
	Item.set_texture(IconTextures[upgrade_type])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###
func has_point(point):
	return true_rect2.has_point(point) and is_visible_in_tree()

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

