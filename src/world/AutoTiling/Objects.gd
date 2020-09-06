tool
class_name ObjectManager extends YSort

#### VARS ####

# enums
enum Tiles {EMPTY = -1, DOOR_EW, DOOR_NS, CONTROL_BOARD, UPGRADE_SCREEN}

# consts
const Scenes := {
		DOOR_EW = preload("res://Scenes/Objects/Door EW.tscn"),
		DOOR_NS = preload("res://Scenes/Objects/Door NS.tscn"),
		CONTROL_BOARD = preload("res://Scenes/Objects/Control Board.tscn"),
		UPGRADE_SCREEN = preload("res://Scenes/Objects/Upgrade Screen.tscn")
	}


# settings
export(Vector2) var cell_size := Vector2(32, 32)

# singletons
# nodes
onready var StaticsNode := $Statics
onready var BugsNode := $Mobs/Bugs
onready var AlliesNode := $Mobs/Allies
onready var player := $Mobs/Allies/Player
onready var robo := $Mobs/Allies/Robo

# public
# private
# signals

#--# VARS #--#



#### MAIN METHODS ####


func _ready():
	
	if Engine.editor_hint:
		return
	
	add_to_group(Groups.SAVABLES)
	
	for c in StaticsNode.get_children():
		if c.has_method("_on_parrent_ready"):
			c._on_parrent_ready()
	
	PlayerInventory.robo = robo
	PlayerInventory.player = player
	
	PlayerInventory.update_mob_stats_watchers()


func _unhandled_input(event:InputEvent):
	
	if not event is InputEventMouseButton:
		return
	
	if Engine.editor_hint:
		return
		
	if SceneManager.view_case != SceneManager.Cases.MAP:
		return
	
	if Input.is_action_just_pressed("set") or Input.is_action_just_pressed("reset") and player != null:
		for obj in StaticsNode.get_children():
			
			if not obj.has_method("is_highlighted"):
				continue
			
			var pos:Vector2 = obj.get_target_position() \
				if obj.has_method("get_target_position") \
				else obj.global_position
			
			if obj.is_highlighted():
				if pos.distance_to(player.get_body_global_position()) < PlayerInventory.NEAR:
					obj.activate() 
				else:
					player.move_to_target(obj)
	
	if Input.is_action_just_pressed("reset") and player != null:
		if Mouse.mouse_tool == Mouse.Tools.ARROW:
			player.move_to_mouse()
		elif Mouse.mouse_tool == Mouse.Tools.RADIO and PlayerInventory.robo != null and PlayerInventory.can_radio:
			if player.is_highlighted():
				robo.follow_player()
			else:
				robo.move_to_mouse()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func apply_object(o:Dictionary) -> void:
	
	if StaticsNode == null:
		_ready()
	
	remove_static_objects(o.pos)
	
	var instance:Node2D
	
	match o.tile:
		
		Tiles.DOOR_EW:
			instance = Scenes.DOOR_EW.instance()
			instance.set_name("door ew 1")
			
		Tiles.DOOR_NS:
			instance = Scenes.DOOR_NS.instance()
			instance.set_name("door ns 1")
			
		Tiles.CONTROL_BOARD:
			instance = Scenes.CONTROL_BOARD.instance()
			instance.set_name("control board 1")
		
		Tiles.UPGRADE_SCREEN:
			instance = Scenes.UPGRADE_SCREEN.instance()
			instance.set_name("upgrade screen 1")
			
		Tiles.EMPTY, _:
			return
			
	StaticsNode.add_child(instance)
	instance.position = (o.pos + Vector2(0.5, 0.5)) * cell_size
	instance.set_owner(StaticsNode.owner)


### updates ###
func clear_all_objects():
	
	# clearing all static objects
	for s in StaticsNode.get_children():
		StaticsNode.remove_child(s)
		s.queue_free()
	
	# clearing all hostiles
	for b in BugsNode.get_children():
		BugsNode.remove_child(b)
		b.queue_free()
	
	# clearing player and allies
	for a in AlliesNode.get_children():
		AlliesNode.remove_child(a)
		a.queue_free()


#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####

### gets ###
### bools ###

### utils ###
func remove_static_objects(pos:Vector2) -> void:

	var pos_min := pos * cell_size
	var pos_max := pos_min + cell_size
	for c in StaticsNode.get_children():
		if (pos_min.x <= c.position.x and c.position.x < pos_max.x) \
				and (pos_min.y <= c.position.y and c.position.y < pos_max.y):
			c.queue_free()

#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	return {
		StaticsNode.get_unique_name(): StaticsNode.to_data(),
		BugsNode.get_unique_name(): BugsNode.to_data(),
		AlliesNode.get_unique_name(): AlliesNode.to_data()
	}
	
	
func from_data(data:Dictionary):
	
	if data.has(StaticsNode.get_unique_name()):
		StaticsNode.from_data(data[StaticsNode.get_unique_name()])
	
	if data.has(BugsNode.get_unique_name()):
		BugsNode.from_data(data[BugsNode.get_unique_name()])
	
	if data.has(AlliesNode.get_unique_name()):
		AlliesNode.from_data(data[AlliesNode.get_unique_name()])
	
	for c in StaticsNode.get_children():
		if c.has_method("_on_parrent_ready"):
			c._on_parrent_ready()


func get_unique_name() -> String:
	return name

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
