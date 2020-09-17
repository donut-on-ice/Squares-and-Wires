class_name ee extends TextureButton

#### VARS ####
# enums
enum Textures {IDLE, PRESSED, HOVERED, DISABLED}

# consts
const Skins = [
		[
			preload("res://assets/ui/menu/button_exit.png"),
			preload("res://assets/ui/menu/button_exit_pressed.png"),
			preload("res://assets/ui/menu/button_exit_hovered.png"),
			preload("res://assets/ui/menu/button_exit_disabled.png")
		],
		[
			preload("res://assets/ui/menu/button_saveexit.png"),
			preload("res://assets/ui/menu/button_saveexit_pressed.png"),
			preload("res://assets/ui/menu/button_saveexit_hovered.png"),
			preload("res://assets/ui/menu/button_saveexit_disabled.png")
		]
	]

# settings
export(bool) var can_save:bool = false setget set_can_save

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	on_level_id_change()
	add_to_group(Groups.GAME_STATE_WATCHERS)
	update_textures()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_can_save(b:bool):
	
	can_save = b
	
	update_textures()


### updates ###
func update_textures():
	
	set_normal_texture(Skins[int(can_save)][Textures.IDLE])
	set_pressed_texture(Skins[int(can_save)][Textures.DISABLED])
	set_hover_texture(Skins[int(can_save)][Textures.HOVERED])
	set_disabled_texture(Skins[int(can_save)][Textures.DISABLED])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_level_id_change():
	set_can_save(LevelManager.CurrentLevel != null)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#


func _on_Exit_pressed():
	get_tree().call_group(Groups.MENU_POPUP,
			Groups.MenuPopupFuncs.SET_CASE,
			AreYouSurePopUP.Cases.EXIT_AND_SAVE if can_save else AreYouSurePopUP.Cases.EXIT)
	SceneManager.view_case = SceneManager.Cases.POPUP
	
