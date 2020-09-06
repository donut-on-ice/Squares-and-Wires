class_name MouseToolButton extends TextureButton


#### VARS ####
# enums
enum Tools {ARROW, WIRE, CROWBAR, CUTTER}
enum States {IDLE, HOVERED}

# consts
const BUTTON_DOWN:String = "button_down"
const ON_BUTTON_DOWN:String = "_on_button_down"

const IconHints := {
		Tools.ARROW: "ARROW tool - picks and places components",
		Tools.WIRE: "WIRE tool - places wires",
		Tools.CROWBAR: "WIRE tool - removes components",
		Tools.CUTTER: "WIRE tool - removes wires"
	}

# settings
export(Tools) var mouse_tool_index setget set_mouse_tool_index

# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready() -> void:
	
	if !is_connected(BUTTON_DOWN, self, ON_BUTTON_DOWN):
		connect(BUTTON_DOWN, self, ON_BUTTON_DOWN)
	
	add_to_group(Groups.MOUSE_WATCHERS)
	on_mouse_tool_change()
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

# setters
func set_mouse_tool_index(i:int) -> void:
	mouse_tool_index = i
	update_mouse_tool()


# updates
func update_mouse_tool() -> void:
	if !is_inside_tree():
		return
		
	var i:int
	var j:int
	i = mouse_tool_index
	
	j = States.IDLE
	set_normal_texture(PUtils.path_mouse_tool_buttons[i][j])
	
	j = States.HOVERED
	set_hover_texture(PUtils.path_mouse_tool_buttons[i][j])
	
	hint_tooltip = IconHints[i]

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### utils ###
### bools ###
#--# NON STATE CHANGING METHODS #--#



#### GROUP METHODS ####


func on_mouse_tool_change() -> void:
	
	set_pressed(Mouse.mouse_tool == mouse_tool_index)
	set_disabled(Mouse.mouse_tool == mouse_tool_index)

#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_button_down() -> void:
	Mouse.set_mouse_tool(mouse_tool_index)

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
