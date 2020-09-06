extends Node

#### VARS ####
# enums
enum Slots {
		NONE,
		FIRST,
		SECOND,
		THIRD
	}

enum Levels {
		NONE,
		LEVEL_STRESS_TEST,
		LEVEL_TEST,
		LEVEL_ONE,
		LEVEL_DEMO,
		LEVEL_SHORT_DEMO
	}

# consts
const ACCEPTED_UP_LEVELS := {
		Levels.NONE: [],
		Levels.LEVEL_STRESS_TEST: [],
		Levels.LEVEL_TEST: [0,1,3],
		Levels.LEVEL_ONE: [0,1],
		Levels.LEVEL_DEMO: [0, 1],
		Levels.LEVEL_SHORT_DEMO: [0, 1]
	}


const SAVE_PATH := "res://Saves"

const SavePaths := {
		Slots.FIRST: SAVE_PATH + "/Save1.tres",
		Slots.SECOND: SAVE_PATH + "/Save2.tres",
		Slots.THIRD: SAVE_PATH + "/Save3.tres"
	}

const PackedLevelPaths := {
		Levels.LEVEL_STRESS_TEST: "res://Scenes/Levels/StressTest.tscn",
		Levels.LEVEL_TEST: "res://Scenes/Levels/TestMap.tscn",
		Levels.LEVEL_ONE: "res://Scenes/Levels/StartArea.tscn",
		Levels.LEVEL_DEMO: "res://Scenes/Levels/DemoMap.tscn",
		Levels.LEVEL_SHORT_DEMO: "res://Scenes/Levels/ShortDemoMap.tscn"
	}

const SaveNames := {
		Slots.FIRST: "Slot 1",
		Slots.SECOND: "Slot 2",
		Slots.THIRD: "Slot 3"
	}

# settings
const START_LEVEL = Levels.LEVEL_SHORT_DEMO

# singletons
# nodes
var CurrentLevel:Node2D = null
var Nav2D:Navigation2D = null
var GameWorld:Node2D = null


# public
var current_level_id:int = Levels.NONE setget set_current_level_id
var current_game_slot:int = Slots.NONE setget set_current_game_slot

# private
# signals
#--# VARS #--#


#### MAIN METHODS ####

func _ready():
	
	current_game_slot = Slots.NONE
	var file := File.new()
	var mod_time = 0
	
	if file.file_exists(SavePaths[Slots.FIRST]):
		var mt = file.get_modified_time(SavePaths[Slots.FIRST])
		mod_time = mt if mt >= mod_time else mod_time
		current_game_slot = Slots.FIRST if mt >= mod_time else current_game_slot
	
	if file.file_exists(SavePaths[Slots.SECOND]):
		var mt = file.get_modified_time(SavePaths[Slots.SECOND])
		mod_time = mt if mt >= mod_time else mod_time
		current_game_slot = Slots.SECOND if mt >= mod_time else current_game_slot
	
	if file.file_exists(SavePaths[Slots.THIRD]):
		var mt = file.get_modified_time(SavePaths[Slots.THIRD])
		mod_time = mt if mt >= mod_time else mod_time
		current_game_slot = Slots.THIRD if mt >= mod_time else current_game_slot
	
	set_current_game_slot(current_game_slot)

func start_new_game():
	
	if current_game_slot == Slots.NONE:
		return
	
	PlayerInventory.set_component_counts_from_preset(PlayerInventory.Presets.EMPTY)
	PlayerInventory.player_upgrades.clear()
	PlayerInventory.upgrades.clear()
	PlayerInventory.robo_upgrades.clear()
	
	set_current_level_id(START_LEVEL)
	
	SceneManager.view_case = SceneManager.Cases.MAP


func continue_game():
	
	if current_game_slot == Slots.NONE:
		return

	if CurrentLevel == null:
		load_game(current_game_slot)
	
	SceneManager.view_case = SceneManager.Cases.MAP


func save_game(slot:int, save_name:String):

	if slot == Slots.NONE:
		return
	
	var save_data := {}
	
	for s in get_tree().get_nodes_in_group(Groups.SAVABLES):
		save_data[s.get_unique_name()] = s.to_data()
		
	var dir := Directory.new()
	if !dir.dir_exists(SAVE_PATH):
		dir.make_dir_recursive(SAVE_PATH)
	
	var data := {}
	
	data.level_id = current_level_id
	data.save_data = save_data
	data.save_title = save_name
	data.save_time = Time.new()
	
	var packed_level = PackedLevel.new()
	packed_level.data = data
	
	ResourceSaver.save(SavePaths[slot], packed_level)
	
	SceneManager.view_case = SceneManager.Cases.MENU


func load_game(game_slot:int):
	
	if GameWorld == null:
		return
	
	var packed_level := load(SavePaths[game_slot]) as PackedLevel
	
	if packed_level == null:
		set_current_level_id(Levels.NONE)
		set_current_game_slot(Slots.NONE)
		return
		
	set_current_level_id(packed_level.data.level_id)
	
	if CurrentLevel == null:
		return
	
	for s in get_tree().get_nodes_in_group(Groups.SAVABLES):
		var key:String = s.get_unique_name()
		if packed_level.data.save_data.has(key):
			s.from_data(packed_level.data.save_data[key])

	SceneManager.view_case = SceneManager.Cases.MAP


func exit(save_on_exit:bool = true):
	
	if save_on_exit and current_game_slot != Slots.NONE:
		save_game(current_game_slot, SaveNames[current_game_slot])
	
	get_tree().quit()


func next_level():
	match current_level_id:
		_:
			game_won()


func game_lost():
	set_current_level_id(Levels.NONE)
	set_current_game_slot(Slots.NONE)
	SceneManager.view_case = SceneManager.Cases.MENU


func game_won():
	set_current_level_id(Levels.NONE)
	set_current_game_slot(Slots.NONE)
	SceneManager.view_case = SceneManager.Cases.MENU

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_current_level_id(id:int):
	
	if GameWorld == null:
		return
	
	if CurrentLevel != null:
		GameWorld.remove_child(CurrentLevel)
		CurrentLevel.queue_free()
	
	current_level_id = id
	
	if id != Levels.NONE:
		CurrentLevel = load(PackedLevelPaths[id]).instance() as Node2D
	
	if CurrentLevel != null:
		GameWorld.add_child(CurrentLevel)
		GameWorld.move_child(CurrentLevel, 0)
	
	get_tree().call_group(Groups.GAME_STATE_WATCHERS,
			Groups.GameStateWatcherFuncs.ON_LEVEL_ID_CHANGE)


func set_current_game_slot(slot:int):
	current_game_slot = slot
	get_tree().call_group(Groups.GAME_STATE_WATCHERS,
			Groups.GameStateWatcherFuncs.ON_GAME_SLOT_CHANGE) 

### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
func get_currently_accepted_up_levels() -> Array:
	return ACCEPTED_UP_LEVELS[current_level_id]


### bools ###
func can_save() -> bool:
	return CurrentLevel != null and current_level_id != Levels.NONE

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
