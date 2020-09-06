class_name LockpadKey extends TextureButton
# extends LockpadStateWatcher

#### VARS ####
# enums
enum Textures {NORMAL, PRESSED, HOVERED}

# consts
const Skins := [
		[
			[
				preload("res://assets/ui/lockpad/0_button_idle.png"),
				preload("res://assets/ui/lockpad/0_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/0_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/0_button_checked.png"),
				preload("res://assets/ui/lockpad/0_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/0_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/1_button_idle.png"),
				preload("res://assets/ui/lockpad/1_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/1_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/1_button_checked.png"),
				preload("res://assets/ui/lockpad/1_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/1_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/2_button_idle.png"),
				preload("res://assets/ui/lockpad/2_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/2_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/2_button_checked.png"),
				preload("res://assets/ui/lockpad/2_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/2_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/3_button_idle.png"),
				preload("res://assets/ui/lockpad/3_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/3_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/3_button_checked.png"),
				preload("res://assets/ui/lockpad/3_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/3_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/4_button_idle.png"),
				preload("res://assets/ui/lockpad/4_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/4_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/4_button_checked.png"),
				preload("res://assets/ui/lockpad/4_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/4_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/5_button_idle.png"),
				preload("res://assets/ui/lockpad/5_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/5_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/5_button_checked.png"),
				preload("res://assets/ui/lockpad/5_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/5_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/6_button_idle.png"),
				preload("res://assets/ui/lockpad/6_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/6_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/6_button_checked.png"),
				preload("res://assets/ui/lockpad/6_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/6_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/7_button_idle.png"),
				preload("res://assets/ui/lockpad/7_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/7_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/7_button_checked.png"),
				preload("res://assets/ui/lockpad/7_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/7_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/8_button_idle.png"),
				preload("res://assets/ui/lockpad/8_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/8_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/8_button_checked.png"),
				preload("res://assets/ui/lockpad/8_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/8_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/9_button_idle.png"),
				preload("res://assets/ui/lockpad/9_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/9_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/9_button_checked.png"),
				preload("res://assets/ui/lockpad/9_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/9_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/A_button_idle.png"),
				preload("res://assets/ui/lockpad/A_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/A_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/A_button_checked.png"),
				preload("res://assets/ui/lockpad/A_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/A_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/B_button_idle.png"),
				preload("res://assets/ui/lockpad/B_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/B_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/B_button_checked.png"),
				preload("res://assets/ui/lockpad/B_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/B_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/C_button_idle.png"),
				preload("res://assets/ui/lockpad/C_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/C_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/C_button_checked.png"),
				preload("res://assets/ui/lockpad/C_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/C_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/D_button_idle.png"),
				preload("res://assets/ui/lockpad/D_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/D_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/D_button_checked.png"),
				preload("res://assets/ui/lockpad/D_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/D_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/E_button_idle.png"),
				preload("res://assets/ui/lockpad/E_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/E_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/E_button_checked.png"),
				preload("res://assets/ui/lockpad/E_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/E_button_checked_hovered.png")
			]
		],
		[
			[
				preload("res://assets/ui/lockpad/F_button_idle.png"),
				preload("res://assets/ui/lockpad/F_button_idle_pressed.png"),
				preload("res://assets/ui/lockpad/F_button_idle_hovered.png")
			],
			[
				preload("res://assets/ui/lockpad/F_button_checked.png"),
				preload("res://assets/ui/lockpad/F_button_checked_pressed.png"),
				preload("res://assets/ui/lockpad/F_button_checked_hovered.png")
			]
		]
	]

const Hints := [
		"(W, X, Y, Z) = (0, 0, 0, 0)",
		"(W, X, Y, Z) = (0, 0, 0, 1)",
		"(W, X, Y, Z) = (0, 0, 1, 0)",
		"(W, X, Y, Z) = (0, 0, 1, 1)",
		"(W, X, Y, Z) = (0, 1, 0, 0)",
		"(W, X, Y, Z) = (0, 1, 0, 1)",
		"(W, X, Y, Z) = (0, 1, 1, 0)",
		"(W, X, Y, Z) = (0, 1, 1, 1)",
		"(W, X, Y, Z) = (1, 0, 0, 0)",
		"(W, X, Y, Z) = (1, 0, 0, 1)",
		"(W, X, Y, Z) = (1, 0, 1, 0)",
		"(W, X, Y, Z) = (1, 0, 1, 1)",
		"(W, X, Y, Z) = (1, 1, 0, 0)",
		"(W, X, Y, Z) = (1, 1, 0, 1)",
		"(W, X, Y, Z) = (1, 1, 1, 0)",
		"(W, X, Y, Z) = (1, 1, 1, 1)"
	]

# settings
export(int, 0, 15) var index:int = 0 setget set_index
export(bool) var is_checked := false setget set_checked

# singletons
# nodes
onready var LPStateWatcher:LockpadStateWatcher = $LockpadStateWatcehr

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	LPStateWatcher.notify_parent = true

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_index(i:int):
	
	index = i
	
	update_textures()


func set_checked(b:bool):
	
	is_checked = b
	
	update_textures()


### updates ###
func update_textures():
	
	var i := index
	var j := int(is_checked)
	var k:int
	
	k = Textures.NORMAL
	set_normal_texture(Skins[i][j][k])
	k = Textures.HOVERED
	set_hover_texture(Skins[i][j][k])
	k = Textures.PRESSED
	set_pressed_texture(Skins[i][j][k])
	set_tooltip(Hints[i])

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_solution_change():
	set_checked(LPStateWatcher.StateHolder.get_solution_bit(index))

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_LockpadKey_pressed() -> void:
	if LPStateWatcher == null:
		return
	
	LPStateWatcher.StateHolder.set_solution_bit(index, !is_checked)
	
	#LockpadStateHolder.set_active(index, is_checked)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
