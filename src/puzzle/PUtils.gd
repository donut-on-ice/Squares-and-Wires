extends Node

const TILE_SIZE:int = 32

const MAX_I: = [2, 6, 8, 2]
const MIN_I: = [2, 4, 6, 2]

const MAX_I_SIDES: = [1, 2, 2, 1]

const MAX_O: = [1, 1, 4, 2]
const MIN_O: = [1, 1, 2, 2]

const MAX_O_SIDES: = [1, 1, 2, 1]

const MAX_X: = [16, 24, 32, 10]
const MIN_X: = [ 8, 12, 12, 10]

const MAX_Y: = [16, 24, 32, 10]
const MIN_Y: = [ 8, 12, 12, 10]

enum SimpleOrientation {W, E, S, N} 
const SO_ATL_POS:Array = [
		Vector2( 0, 0), Vector2( 1, 0), Vector2( 2, 0), Vector2( 3, 0)]
enum MultiOrientation {
		NONE,    W,    E,   EW,
		   S,   SW,   SE,  SEW,
		   N,   NW,   NE,  NEW,
		  NS,  NSW,  NSE, NSEW}
const MO_ATL_POS:Array = [
		Vector2( 0, 0), Vector2( 1, 0), Vector2( 2, 0), Vector2( 3, 0),
		Vector2( 4, 0), Vector2( 5, 0), Vector2( 6, 0), Vector2( 7, 0),
		Vector2( 8, 0), Vector2( 9, 0), Vector2(10, 0), Vector2(11, 0),
		Vector2(12, 0), Vector2(13, 0), Vector2(14, 0), Vector2(15, 0)]
const TECH_ATL_POS:Array = [
		[Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
		[Vector2(0, 1), Vector2(1, 1), Vector2(2, 1)],
		[Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)]]
enum LogicState {OFF, FALSE, TRUE, UNDEFINED}
const paths_in_out = [
		preload("res://assets/ui/labels/i.png"),
		preload("res://assets/ui/labels/o.png")]

const path_digits = [
		preload("res://assets/ui/labels/0.png"),
		preload("res://assets/ui/labels/1.png"),
		preload("res://assets/ui/labels/2.png"),
		preload("res://assets/ui/labels/3.png"),
		preload("res://assets/ui/labels/4.png"),
		preload("res://assets/ui/labels/5.png"),
		preload("res://assets/ui/labels/6.png"),
		preload("res://assets/ui/labels/7.png"),
		preload("res://assets/ui/labels/8.png"),
		preload("res://assets/ui/labels/9.png"),
		preload("res://assets/ui/labels/space.png")]

enum MaskType {CLICKED, EMPTY, HOVERED, SELECTED}
const path_button_masks = [
		[
			[
				preload("res://assets/ui/io_panels/mask_clciked_1x1.png"),
				preload("res://assets/ui/io_panels/mask_clciked_1x2.png"),
				preload("res://assets/ui/io_panels/mask_clciked_1x3.png"),
				preload("res://assets/ui/io_panels/mask_clciked_1x4.png")
			],
			[
				preload("res://assets/ui/io_panels/mask_clciked_2x1.png"),
				preload("res://assets/ui/io_panels/mask_clciked_2x2.png"),
				preload("res://assets/ui/io_panels/mask_clciked_2x3.png"),
				preload("res://assets/ui/io_panels/mask_clciked_2x4.png")
			]
		],
		[
			[
				preload("res://assets/ui/io_panels/mask_empty_1x1.png"),
				preload("res://assets/ui/io_panels/mask_empty_1x2.png"),
				preload("res://assets/ui/io_panels/mask_empty_1x3.png"),
				preload("res://assets/ui/io_panels/mask_empty_1x4.png")
			],
			[
				preload("res://assets/ui/io_panels/mask_empty_2x1.png"),
				preload("res://assets/ui/io_panels/mask_empty_2x2.png"),
				preload("res://assets/ui/io_panels/mask_empty_2x3.png"),
				preload("res://assets/ui/io_panels/mask_empty_2x4.png")
			]
		],
		[
			[
				preload("res://assets/ui/io_panels/mask_hoverd_1x1.png"),
				preload("res://assets/ui/io_panels/mask_hoverd_1x2.png"),
				preload("res://assets/ui/io_panels/mask_hoverd_1x3.png"),
				preload("res://assets/ui/io_panels/mask_hoverd_1x4.png")
			],
			[
				preload("res://assets/ui/io_panels/mask_hoverd_2x1.png"),
				preload("res://assets/ui/io_panels/mask_hoverd_2x2.png"),
				preload("res://assets/ui/io_panels/mask_hoverd_2x3.png"),
				preload("res://assets/ui/io_panels/mask_hoverd_2x4.png")
			]
		],
		[
			[
				preload("res://assets/ui/io_panels/mask_selected_1x1.png"),
				preload("res://assets/ui/io_panels/mask_selected_1x2.png"),
				preload("res://assets/ui/io_panels/mask_selected_1x3.png"),
				preload("res://assets/ui/io_panels/mask_selected_1x4.png")
			],
			[
				preload("res://assets/ui/io_panels/mask_selected_2x1.png"),
				preload("res://assets/ui/io_panels/mask_selected_2x2.png"),
				preload("res://assets/ui/io_panels/mask_selected_2x3.png"),
				preload("res://assets/ui/io_panels/mask_selected_2x4.png")
			]
		]
	]
const path_tables= [
		[
			preload("res://assets/ui/io_panels/table_1x2.png"),
			preload("res://assets/ui/io_panels/table_1x4.png"),
			preload("res://assets/ui/io_panels/table_1x8.png"),
			preload("res://assets/ui/io_panels/table_1x16.png")
		],
		[
			preload("res://assets/ui/io_panels/table_2x2.png"),
			preload("res://assets/ui/io_panels/table_2x4.png"),
			preload("res://assets/ui/io_panels/table_2x8.png"),
			preload("res://assets/ui/io_panels/table_2x16.png")
		],
		[
			preload("res://assets/ui/io_panels/table_3x2.png"),
			preload("res://assets/ui/io_panels/table_3x4.png"),
			preload("res://assets/ui/io_panels/table_3x8.png"),
			preload("res://assets/ui/io_panels/table_3x16.png")
		],
		[
			preload("res://assets/ui/io_panels/table_4x2.png"),
			preload("res://assets/ui/io_panels/table_4x4.png"),
			preload("res://assets/ui/io_panels/table_4x8.png"),
			preload("res://assets/ui/io_panels/table_4x16.png")
		]
	]
const paths_input_ls = [
		preload("res://assets/ui/io_panels/in_light_red.png"),
		preload("res://assets/ui/io_panels/in_light_green.png")
	]
const paths_output_ls = [
		preload("res://assets/ui/io_panels/out_light_black.png"),
		preload("res://assets/ui/io_panels/out_light_red.png"),
		preload("res://assets/ui/io_panels/out_light_green.png"),
		preload("res://assets/ui/io_panels/out_light_yellow.png")
	]
const paths_required_output_ls = [
		preload("res://assets/ui/io_panels/required_out_light_red.png"),
		preload("res://assets/ui/io_panels/required_out_light_green.png")
	]
enum InputPanelButtonStates {IDLE, HOVERED, CLICKED}
enum InputPanelLights {RED, GREEN}
# a[RED|GREEN][I1|I2|I3|I4][IDLE|HOVERED|CLICKED]
const input_panel_buttons = [
		[
			[
				preload("res://assets/ui/io_panels/i1_red_button_idle.png"),
				preload("res://assets/ui/io_panels/i1_red_button_hovered.png"),
				preload("res://assets/ui/io_panels/i1_red_button_clicked.png")
			],[
				preload("res://assets/ui/io_panels/i2_red_button_idle.png"),
				preload("res://assets/ui/io_panels/i2_red_button_hovered.png"),
				preload("res://assets/ui/io_panels/i2_red_button_clicked.png")
			],[
				preload("res://assets/ui/io_panels/i3_red_button_idle.png"),
				preload("res://assets/ui/io_panels/i3_red_button_hovered.png"),
				preload("res://assets/ui/io_panels/i3_red_button_clicked.png")
			],[
				preload("res://assets/ui/io_panels/i4_red_button_idle.png"),
				preload("res://assets/ui/io_panels/i4_red_button_hovered.png"),
				preload("res://assets/ui/io_panels/i4_red_button_clicked.png")
			]
		],[
			[
				preload("res://assets/ui/io_panels/i1_green_button_idle.png"),
				preload("res://assets/ui/io_panels/i1_green_button_hovered.png"),
				preload("res://assets/ui/io_panels/i1_green_button_clicked.png")
			],[
				preload("res://assets/ui/io_panels/i2_green_button_idle.png"),
				preload("res://assets/ui/io_panels/i2_green_button_hovered.png"),
				preload("res://assets/ui/io_panels/i2_green_button_clicked.png")
			],[
				preload("res://assets/ui/io_panels/i3_green_button_idle.png"),
				preload("res://assets/ui/io_panels/i3_green_button_hovered.png"),
				preload("res://assets/ui/io_panels/i3_green_button_clicked.png")
			],[
				preload("res://assets/ui/io_panels/i4_green_button_idle.png"),
				preload("res://assets/ui/io_panels/i4_green_button_hovered.png"),
				preload("res://assets/ui/io_panels/i4_green_button_clicked.png")
			]
		]
	]

const path_mouse_tool_buttons = [
		[
			preload("res://assets/ui/tools_panel/arrow_icon_idle.png"),
			preload("res://assets/ui/tools_panel/arrow_icon_hovered.png")
		],
		[
			preload("res://assets/ui/tools_panel/wire_icon_idle.png"),
			preload("res://assets/ui/tools_panel/wire_icon_hovered.png")
		],
		[
			preload("res://assets/ui/tools_panel/crowbar_icon_idle.png"),
			preload("res://assets/ui/tools_panel/crowbar_icon_hovered.png")
		],
		[
			preload("res://assets/ui/tools_panel/cutters_icon_idle.png"),
			preload("res://assets/ui/tools_panel/cutters_icon_hovered.png")
		]
	]

# a[comp_type][idle|selected][normal|hovered|pressed]
const components_button_icons:Array = [
		[
			[
				preload("res://assets/ui/components_panel/not_gate_button_idle.png"),
				preload("res://assets/ui/components_panel/not_gate_button_idle_hovered.png"),
				preload("res://assets/ui/components_panel/not_gate_button_idle_pressed.png")
			],[
				preload("res://assets/ui/components_panel/not_gate_button_selected.png"),
				preload("res://assets/ui/components_panel/not_gate_button_selected_hovered.png"),
				preload("res://assets/ui/components_panel/not_gate_button_selected_pressed.png")
			]
		],[
			[
				preload("res://assets/ui/components_panel/and_gate_button_idle.png"),
				preload("res://assets/ui/components_panel/and_gate_button_idle_hovered.png"),
				preload("res://assets/ui/components_panel/and_gate_button_idle_pressed.png")
			],[
				preload("res://assets/ui/components_panel/and_gate_button_selected.png"),
				preload("res://assets/ui/components_panel/and_gate_button_selected_hovered.png"),
				preload("res://assets/ui/components_panel/and_gate_button_selected_pressed.png")
			]
		],[
			[
				preload("res://assets/ui/components_panel/or_gate_button_idle.png"),
				preload("res://assets/ui/components_panel/or_gate_button_idle_hovered.png"),
				preload("res://assets/ui/components_panel/or_gate_button_idle_pressed.png")
			],[
				preload("res://assets/ui/components_panel/or_gate_button_selected.png"),
				preload("res://assets/ui/components_panel/or_gate_button_selected_hovered.png"),
				preload("res://assets/ui/components_panel/or_gate_button_selected_pressed.png")
			]
		],[
			[
				preload("res://assets/ui/components_panel/xor_gate_button_idle.png"),
				preload("res://assets/ui/components_panel/xor_gate_button_idle_hovered.png"),
				preload("res://assets/ui/components_panel/xor_gate_button_idle_pressed.png")
			],[
				preload("res://assets/ui/components_panel/xor_gate_button_selected.png"),
				preload("res://assets/ui/components_panel/xor_gate_button_selected_hovered.png"),
				preload("res://assets/ui/components_panel/xor_gate_button_selected_pressed.png")
			]
		],[
			[
				preload("res://assets/ui/components_panel/over_bridge_button_idle.png"),
				preload("res://assets/ui/components_panel/over_bridge_button_idle_hovered.png"),
				preload("res://assets/ui/components_panel/over_bridge_button_idle_pressed.png")
			],[
				preload("res://assets/ui/components_panel/over_bridge_button_selected.png"),
				preload("res://assets/ui/components_panel/over_bridge_button_selected_hovered.png"),
				preload("res://assets/ui/components_panel/over_bridge_button_selected_pressed.png")
			]
		],[
			[
				preload("res://assets/ui/components_panel/under_bridge_button_idle.png"),
				preload("res://assets/ui/components_panel/under_bridge_button_idle_hovered.png"),
				preload("res://assets/ui/components_panel/under_bridge_button_idle_pressed.png")
			],[
				preload("res://assets/ui/components_panel/under_bridge_button_selected.png"),
				preload("res://assets/ui/components_panel/under_bridge_button_selected_hovered.png"),
				preload("res://assets/ui/components_panel/under_bridge_button_selected_pressed.png")
			]
		]
		
	]


### helpers
static func get_so_atl_pos(so:int) -> Vector2:
	return SO_ATL_POS[Utils.clamp_int(so, 0, SO_ATL_POS.size())]


static func get_mo_atl_pos(mo:int) -> Vector2:
	return MO_ATL_POS[Utils.clamp_int(mo, 0, MO_ATL_POS.size())]


static func get_a_towards_b_dir_mo(from:Point, to:Point) -> int:
	var x = to.x - from.x
	var y = to.y - from.y
	if x == -1 && y ==  0:
		return MultiOrientation.W
	if x ==  1 && y ==  0:
		return MultiOrientation.E
	if x ==  0 && y ==  1:
		return MultiOrientation.S
	if x ==  0 && y == -1:
		return MultiOrientation.N
	return MultiOrientation.NONE


static func get_a_towards_b_dir_so(from:Point, to:Point) -> int:
	var x = to.x - from.x
	var y = to.y - from.y
	if x == -1 && y ==  0:
		return SimpleOrientation.W
	if x ==  1 && y ==  0:
		return SimpleOrientation.E
	if x ==  0 && y ==  1:
		return SimpleOrientation.S
	if x ==  0 && y == -1:
		return SimpleOrientation.N
	return -1


static func get_tile_direction(tm:TileMap, x:int, y:int) -> int:
	return int(tm.get_cell_autotile_coord(x, y).x)


static func so_to_mo(so:int) -> int:
	match so:
		SimpleOrientation.E:
			return MultiOrientation.E
		SimpleOrientation.W:
			return MultiOrientation.W
		SimpleOrientation.S:
			return MultiOrientation.S
		SimpleOrientation.N:
			return MultiOrientation.N
	return MultiOrientation.NONE


static func bool_2bit_to_1bit(large:int) -> int:
	var small := 0
	
	for i in range(Utils.INT_BITS / 2):
		small |= int(large >> 2*i & 0b11 == LogicState.TRUE) << i
		
	return small


static func bool_2bit_to_string(large:int) -> String:
	var out = ""
	
	for _step in range(16):
		match large & 0b11:
			0b00: out += "|--|"
			0b01: out += "| F|"
			0b10: out += "|A |"
			0b11: out += "|EE|"
		large = large >> 2
	
	return out 


static func bool_1bit_to_2bit(small:int) -> int:
	var large := 0
	
	for i in range(Utils.INT_BITS / 2):
		large |= (LogicState.TRUE if bool(small & 0b1 << i) else LogicState.FALSE) << 2*i
		
	return large


### bools
static func is_logic_sate(ls:int) -> bool: 
	return 0 <= ls && ls <= LogicState.UNDEFINED


static func is_simple_orientation(dir:int) -> bool: 
	return 0 <= dir && dir <= SimpleOrientation.N


static func is_multi_orientation(dir:int) -> bool: 
	return 0 <= dir && dir <= MultiOrientation.NSEW


static func are_adjacent(from:Point, to:Point) -> bool:
	return get_a_towards_b_dir_mo(from, to) != MultiOrientation.NONE


static func get_neighbour_pos(me:Point, so_direction:int) -> Point:
	match so_direction:
		SimpleOrientation.E:
			return Point.new(me.x + 1, me.y)
		SimpleOrientation.W:
			return Point.new(me.x - 1, me.y)
		SimpleOrientation.S:
			return Point.new(me.x, me.y + 1)
		SimpleOrientation.N:
			return Point.new(me.x, me.y - 1)
	return null
