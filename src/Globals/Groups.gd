class_name Groups extends Node

# group names
const PUZZLE_LAYER_HOLDERS		:= "PuzzleLayerHolders"
const PUZZLE_LAYER_WATCHERS		:= "PuzzleLayerWatchers"
const IO_STATE_HOLDERS			:= "IOStateHolders"
const IO_STATE_WATCHERS			:= "IOStateWatchers"
const MOUSE_WATCHERS			:= "MouseWatchers"
const CAMERA_HOLDERS			:= "CameraHolders"
const CAMERA_WATCHERS			:= "CameraWatchers"
const LOCKPAD_STATE_WATCHERS	:= "LockpadStateWatchers"
const LOCKPAD_STATE_HOLDERS		:= "LockpadStateHOLDERS"
const PUZZLE_OVERVIEW			:= "PuzzleOverview"
const SHINERS					:= "Shiners"
const MENU_POPUP				:= "MenuPopup"
const PLAYER_INVENTORY_WATCHERS	:= "PlayerInventoryWatchers"
const SAVABLES					:= "Savables"
const PLAYER_VISION				:= "PlayerVision"
const PAUSABLES					:= "Pausables"
const GAME_STATE_WATCHERS		:= "GameStateWatchers"

# group functions
const PuzzleLayerHolderFuncs := {
		ON_PUZZLE_LAYER_HOLDER_CHANGE	= "on_puzzle_layer_holder_change",
		ON_NODE_IS_READY				= "on_node_is_ready"
	}

const PuzzleLayerWatcherFuncs := {
		ON_PUZZLE_LAYER_HOLDER_CHANGE = "on_puzzle_layer_holder_change"
	}

const  IOStateHolderFuncs := {
		ON_IO_STATE_HOLDER_CHANGE	= "on_io_state_holder_change",
		ON_NODE_IS_READY			= "on_node_is_ready"
	}

const  IOStateWatcherFuncs := {
		ON_IO_STATE_HOLDER_CHANGE			= "on_io_state_holder_change",
		ON_INPUT_STATE_CHANGE				= "on_input_state_change",
		ON_INPUT_NR_CHANGE					= "on_input_nr_change",
		ON_REQUIRED_OUTPUT_STATES_CHANGE	= "on_required_output_states_change",
		ON_OUTPUT_STATES_CHANGE				= "on_output_states_change",
		ON_OUTPUT_NR_CHANGE					= "on_output_nr_change"
	}

const  MouseWatcherFuncs := {
		ON_MOUSE_TOOL_CHANGE			= "on_mouse_tool_change",
		ON_SELECTED_COMPONENT_CHANGE	= "on_selected_component_change"
	}

const  CameraHolderFuncs := {
		ON_CAMERA_HOLDER_CHANGE	= "on_camera_holder_change",
		ON_NODE_IS_READY		= "on_node_is_ready"
}

const  CameraWatcherFuncs := {
		ON_CAMERA_HOLDER_CHANGE = "on_camera_holder_change"
	}

const LockpadStateWatcherFuncs := {
		ON_REQUIRED_FORMULA_TYPE_CHANGE	= "on_required_formula_type_change",
		ON_LOCKPAD_STATE_HOLDER_CHANGE	= "on_lockpad_state_holder_change",
		ON_SOLUTION_CHANGE				= "on_solution_change",
		ON_NODE_IS_READY				= "on_node_is_ready"
	}

const LockpadStateHolderFuncs := {
		ON_LOCKPAD_STATE_HOLDER_CHANGE = "on_lockpad_state_holder_change",
		SET_CURRENT_TOOLBOX = "set_current_toolbox"
	}

const PuzzleOverviewFuncs := {
		SET_CONTROL_BOARD = "set_control_board"
	}

const  ShinersFuncs := {
		START_SHINING = "start_shining"
	}

const MenuPopupFuncs := {
		SET_CASE = "set_case"
	}

const PlayerInventoryWatcherFuncs := {
		ON_COMPONENT_COUNTS_CHANGE = "on_component_counts_change",
		ON_MOB_STATS_CHANGE = "on_mob_stats_change",
		ON_CAN_RADIO_CHANGE = "on_can_radio_change",
		ON_UPGRADES_CHANGE = "on_upgrades_change",
		ON_ADDITION = "on_addition"
	}

const SavableFuncs := {
		GET_UNIQUE_NAME = "get_unique_name",
		TO_DATA = "to_data",
		FROM_DATA = "from_data"
	}
	
const PlayerVisionFuncs := {
		UNFOG = "unfog"
	}

const PausableFuncs := {
		ON_VIEW_CASE_CHANGE = "on_view_case_change",
		ON_INFO_VISIBLE_CHANGE = "on_info_visible_change"
	}

const GameStateWatcherFuncs := {
		ON_GAME_SLOT_CHANGE = "on_game_slot_change",
		ON_LEVEL_ID_CHANGE = "on_level_id_change"
	}
