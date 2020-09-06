class_name ComponentButton extends VBoxContainer



#### VARS ####
# enums
enum ComponentTypes {NOT, AND, OR, XOR, OVER, UNDER}
enum Textures {NORMAL, HOVERED, PRESSED} 

# consts
const ButtonHints := {
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
onready var LEDButton:TextureButton = $LEDButton
onready var Nr:Number = $NrMargin/NrCenter/Nr

# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	add_to_group(Groups.MOUSE_WATCHERS)
	add_to_group(Groups.PLAYER_INVENTORY_WATCHERS)
	on_selected_component_change()
	on_component_counts_change()
	update_number()
	update_textures()

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_type(i:int) -> void:
	type = i
	update_textures()


# updates
func update_textures() -> void:
	if !is_inside_tree():
		return
	
	var is_selected = Mouse.selected_component == type
	var i:int
	var j:int
	var k:int
	i = type
	j = is_selected
	
	k = Textures.NORMAL
	LEDButton.set_normal_texture(PUtils.components_button_icons[i][j][k])
	k = Textures.HOVERED
	LEDButton.set_hover_texture(PUtils.components_button_icons[i][j][k])
	k = Textures.PRESSED
	LEDButton.set_pressed_texture(PUtils.components_button_icons[i][j][k])
	LEDButton.set_disabled_texture(PUtils.components_button_icons[i][j][k])
	
	LEDButton.hint_tooltip = ButtonHints[type]


func update_number() -> void:
	if !is_inside_tree():
		return
	
	Nr.set_number(PlayerInventory.component_counts[type])
	LEDButton.set_disabled(PlayerInventory.component_counts[type] == 0)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####

func on_selected_component_change() -> void:
	update_textures()


func on_component_counts_change() -> void:
	update_number()

#--# GROUP METHODS #--# 


#### SIGNAL METHODS ####

func _on_LEDButton_pressed() -> void:
	
	Mouse.set_selected_component(Component.Types.NONE \
			if Mouse.selected_component == type \
			else type)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
