class_name LockpadEnterKey extends TextureButton
# extends LockpadStateWatcher

#### VARS ####
# enums
enum Types {NONE, SUM, PRODUCT} 
enum Textures {NORMAL, PRESSED, HOVERED}

# consts
const Skins := [
		[
			preload("res://assets/ui/lockpad/enter_button.png"),
			preload("res://assets/ui/lockpad/enter_button_pressed.png"),
			preload("res://assets/ui/lockpad/enter_button_hovered.png")
		],
		[
			preload("res://assets/ui/lockpad/enter_sum_of_products_button.png"),
			preload("res://assets/ui/lockpad/enter_sum_of_products_button_pressed.png"),
			preload("res://assets/ui/lockpad/enter_sum_of_products_button_hovered.png")
		],
		[
			preload("res://assets/ui/lockpad/enter_product_of_sums_button.png"),
			preload("res://assets/ui/lockpad/enter_product_of_sums_button_pressed.png"),
			preload("res://assets/ui/lockpad/enter_product_of_sums_button_hovered.png")
		]
	]

const Hints := [
		"",
		"Sum of Products\nfor (W, X, Y, Z)",
		"Product of Sums\nfor (W, X, Y, Z)"
	]

# settings
export(Types) var type := Types.NONE setget set_type

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func set_type(i:int):
	type = i
	update_textures()


### updates ###
func update_textures():
	set_normal_texture(Skins[type][Textures.NORMAL])
	set_hover_texture(Skins[type][Textures.HOVERED])
	set_pressed_texture(Skins[type][Textures.PRESSED])
	set_tooltip(Hints[type])
	

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
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#


func _on_Enter_pressed():
	SceneManager.view_case = SceneManager.Cases.MAP
