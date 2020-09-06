class_name InventoryGUI extends Control

#### VARS ####
# enums
# consts
const NR_START_POS = 3
const NR_END_POS = 7

# settings
# singletons
# nodes
onready var Inventory:GridContainer = $Content/MainScreen/Content/Store/Items
onready var PlayerSlots := $Content/MainScreen/Content/Player/Items.get_children()
onready var InventorySlots := Inventory.get_children()
onready var RoboSlots := $Content/MainScreen/Content/Robo/Items.get_children()

onready var PlayerInventoryStats := $Content/Player/Bg/Stats
onready var RoboInventoryStats := $Content/Robo/Bg/Stats

onready var PlayerStatsText:PoolStringArray = PlayerInventoryStats.text.split("\n")
onready var RoboStatsText:PoolStringArray = RoboInventoryStats.text.split("\n")

onready var PickedItem := $SelectedItem

# public
# private
var scrolled_rows:int = 0

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	for i in range(PlayerSlots.size()):
		var slot:ItemSlot = PlayerSlots[i]
		slot.slot_type = ItemSlot.SlotTypes.PLAYER_EQUIP
		slot.index = i
		slot.InventoryGui = self

	for i in range(InventorySlots.size()):
		var slot:ItemSlot = InventorySlots[i]
		slot.slot_type = ItemSlot.SlotTypes.INVENTORY
		slot.index = i
		slot.InventoryGui = self

	for i in range(RoboSlots.size()):
		var slot:ItemSlot = RoboSlots[i]
		slot.slot_type = ItemSlot.SlotTypes.ROBO_EQUIP
		slot.index = i
		slot.InventoryGui = self
	
	on_upgrades_change()
	on_mob_stats_change()
	add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	
	on_view_case_change()
	add_to_group(Groups.PAUSABLES)
			
	scrolled_rows = 0


func _input(event:InputEvent):
	
	if not visible:
		return
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if Input.is_action_just_released("set") and can_place_here(ItemSlot.SlotTypes.INVENTORY):
			place_here(ItemSlot.SlotTypes.INVENTORY, PlayerInventory.upgrades.size())
			accept_event()
	
	if event.is_action("scroll_up"):
		scrolled_rows = max(scrolled_rows - 1, 0)
		on_upgrades_change()
		accept_event()
	
	if event.is_action("scroll_down"):
		scrolled_rows = min(scrolled_rows + 1,
				PlayerInventory.upgrades.size() / Inventory.columns)
		on_upgrades_change()
		accept_event()

	if Input.is_action_just_released("sort_by_type"):
		PlayerInventory.upgrades.sort_custom(Upgrade, "compare_by_type_then_level")
	
	if Input.is_action_just_released("sort_by_level"):
		PlayerInventory.upgrades.sort_custom(Upgrade, "compare_by_level_then_type")

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func pick(slot_type:int, index:int, hot_spot:Vector2):
	
	if not can_pick(slot_type, index):
		return 
	
	var from := []
	
	match slot_type:
		ItemSlot.SlotTypes.PLAYER_EQUIP: 
			from = PlayerInventory.player_upgrades	
		ItemSlot.SlotTypes.INVENTORY: 
			from = PlayerInventory.upgrades
			index = index + scrolled_rows * Inventory.columns
		ItemSlot.SlotTypes.ROBO_EQUIP: 
			from = PlayerInventory.robo_upgrades
		
	if from.size() > index:
		PickedItem.upgrade = from[index]
		PlayerInventory.sub_upgrade(PickedItem.upgrade)
		from.remove(index)
		PickedItem.hot_spot = hot_spot
		on_upgrades_change()


func place_here(slot_type:int, index:int):
	
	if not can_place_here(slot_type):
		return
	
	var to := []
	
	match slot_type:
		ItemSlot.SlotTypes.PLAYER_EQUIP: 
			to = PlayerInventory.player_upgrades	
		ItemSlot.SlotTypes.INVENTORY: 
			to = PlayerInventory.upgrades
			index = index + scrolled_rows * Inventory.columns
		ItemSlot.SlotTypes.ROBO_EQUIP: 
			to = PlayerInventory.robo_upgrades
	
	if index > to.size():
		to.append(PickedItem.upgrade)
	else:
		to.insert(index, PickedItem.upgrade)
	
	PlayerInventory.add_upgrade(PickedItem.upgrade)
	
	PickedItem.upgrade = null
	
	on_upgrades_change()

### updates ###

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###
func can_pick(slot_type:int, index:int) -> bool:
	
	if PickedItem.upgrade != null:
		return false
	
	match slot_type:
		ItemSlot.SlotTypes.PLAYER_EQUIP: 
			return PlayerInventory.player_upgrades.size() > index
		ItemSlot.SlotTypes.INVENTORY:
			return PlayerInventory.upgrades.size() > index + scrolled_rows * Inventory.columns
		ItemSlot.SlotTypes.ROBO_EQUIP: 
			return PlayerInventory.robo_upgrades.size() > index and PlayerInventory.can_radio
			
	return false


func can_place_here(slot_type:int) -> bool:
	
	if PickedItem.upgrade == null:
		return false
	
	match slot_type:
		ItemSlot.SlotTypes.PLAYER_EQUIP: 
			return PlayerInventory.player_upgrades.size() < PlayerSlots.size()
		ItemSlot.SlotTypes.INVENTORY:
			return true
		ItemSlot.SlotTypes.ROBO_EQUIP: 
			return PlayerInventory.robo_upgrades.size() < RoboSlots.size() and PlayerInventory.can_radio
			
	return false


static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.INVENTORY

### utils ###

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

# PlayerInventoryWatcherFuncs
func on_upgrades_change():
	
	for slot in PlayerSlots:
		slot.update()
	
	var scroll_padding := scrolled_rows * Inventory.columns
	for slot in InventorySlots:
		slot.update(scroll_padding)
	
	for slot in RoboSlots:
		slot.update()


func on_mob_stats_change():
	
	if PlayerInventory.player == null or PlayerInventory.robo == null:
		return
	
	var p_stats = PlayerInventory.player.stats
	var r_stats = PlayerInventory.robo.stats
	var r_atk:Attack = PlayerInventory.robo.AutoAttack.ability


	if p_stats.max_health < 10:
		PlayerStatsText[0][3] = ' '
		PlayerStatsText[0][4] = ' '
		PlayerStatsText[0][5] = String(p_stats.health % 10)
		PlayerStatsText[0][6] = '/'
		PlayerStatsText[0][7] = String(p_stats.max_health % 10)
	else:
		PlayerStatsText[0][3] = String((p_stats.health / 10) % 10)
		PlayerStatsText[0][4] = String(p_stats.health % 10)
		PlayerStatsText[0][5] = '/'
		PlayerStatsText[0][6] = String((p_stats.max_health / 10) % 10)
		PlayerStatsText[0][7] = String(p_stats.max_health % 10)

	PlayerStatsText[1][6] = ' ' if p_stats.armor < 10 else String((p_stats.armor / 10) % 10)
	PlayerStatsText[1][7] = String(p_stats.armor % 10)
	
	PlayerStatsText[3][6] = ' ' if p_stats.sight_range < 10 else String((p_stats.sight_range / 10) % 10)
	PlayerStatsText[3][7] = String(p_stats.sight_range % 10)
	
	PlayerStatsText[4][6] = ' ' if PlayerInventory.player.radio_range < 10 else String((PlayerInventory.player.radio_range / 10) % 10)
	PlayerStatsText[4][7] = String(PlayerInventory.player.radio_range % 10)


	if r_stats.max_health < 10:
		RoboStatsText[0][3] = ' '
		RoboStatsText[0][4] = ' '
		RoboStatsText[0][5] = String(r_stats.health % 10)
		RoboStatsText[0][6] = '/'
		RoboStatsText[0][7] = String(r_stats.max_health % 10)
	else:
		RoboStatsText[0][3] = String((r_stats.health / 10) % 10)
		RoboStatsText[0][4] = String(r_stats.health % 10)
		RoboStatsText[0][5] = '/'
		RoboStatsText[0][6] = String((r_stats.max_health / 10) % 10)
		RoboStatsText[0][7] = String(r_stats.max_health % 10)

	RoboStatsText[1][6] = ' ' if r_stats.armor < 10 else String((r_stats.armor / 10) % 10)
	RoboStatsText[1][7] = String(r_stats.armor % 10)
	
	RoboStatsText[3][6] = ' ' if r_stats.sight_range < 10 else String((r_stats.sight_range / 10) % 10)
	RoboStatsText[3][7] = String(r_stats.sight_range % 10)
	
	RoboStatsText[4][6] = ' ' if PlayerInventory.robo.radio_range < 10 else String((PlayerInventory.robo.radio_range / 10) % 10)
	RoboStatsText[4][7] = String(PlayerInventory.robo.radio_range % 10)

	RoboStatsText[6][5] = ' '
	RoboStatsText[6][6] = ' ' if r_atk.damage < 10 else String((r_atk.damage / 10) % 10)
	RoboStatsText[6][7] = String(r_atk.damage % 10)
	
	RoboStatsText[7][5] = ' '
	RoboStatsText[7][6] = ' ' if r_atk.penetration < 10 else String((r_atk.penetration / 10) % 10)
	RoboStatsText[7][7] = String(r_atk.penetration % 10)

	PlayerInventoryStats.text = PlayerStatsText.join("\n")
	RoboInventoryStats.text = RoboStatsText.join("\n")


# PausableFuncs
func on_view_case_change():
	
	var paused := view_case_to_paused(SceneManager.view_case)
	
	if paused and PickedItem.upgrade != null:
		PlayerInventory.upgrades.append(PickedItem.upgrade)
		PickedItem.upgrade = null
		
	if not paused:
		on_upgrades_change()
	visible = not paused
	scrolled_rows = 0

	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)
	
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
