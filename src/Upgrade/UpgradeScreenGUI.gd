tool
class_name UpgradeScreenGUI extends Control

#### VARS ####
# enums
# consts
const ALL_INVENTORIES_EMPTY_MSG := "No upgrade in your inventory"
const ALL_UPGRADES_DONE_MSG := "You have no more upgrades" + "\n" + "to be leveled up by this table"

# settings
export(Color) var question_modulation := Color.white setget set_question_modulation
export(Color) var chosen_answer_color := Color.white setget set_chosen_answer_color
export(int) var answers_characters_shown := 0 setget set_answers_characters_shown
export(bool) var answers_disabled := true setget set_answers_disabled


# singletons
# nodes
onready var AnswerButtons := $Background/Answers.get_children()
onready var QuestionText := $Top/Center/Margin/Question
onready var UpgradeIcon := $Top/Upgrade
onready var StartBtn := $Top/Case/Start
onready var StopBtn := $Top/Case/Stop
onready var AT := $AnimationTree
onready var state_machine:AnimationNodeStateMachinePlayback = AT.get("parameters/playback")

# public
var pressed_index := 0 setget set_pressed_index

# private
var current_upgrade:Upgrade = null setget set_current_upgrade
var Upgrades := []

# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	
	AnswerButtons.sort_custom(AnswerTextButton, "compare")
	
	for b in AnswerButtons:
		b.ParentGUI = self
	
	AT.advance(0.0)
	reset()

	on_view_case_change()
	add_to_group(Groups.PAUSABLES)

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####

### setters ###
func reset():
	
	pressed_index = 0
	for b in AnswerButtons:
		b.reset()
	
	QuestionText.text = ""
	UpgradeIcon.texture = null	
	set_current_upgrade(null)
	
	Upgrades = PlayerInventory.get_upgradable_upgrades()
	
	state_machine.start("Start")
	
	set_question_modulation(Color.white)
	set_chosen_answer_color(Color.white)
	set_answers_characters_shown(0)
	set_answers_disabled(true)


func set_question_modulation(c:Color):
	question_modulation = c
	
	if QuestionText != null:
		QuestionText.modulate = question_modulation


func set_chosen_answer_color(c:Color):
	chosen_answer_color = c
	
	if pressed_index == 0:
		return
	
	if c == Color.white:
		AnswerButtons[pressed_index - 1].update_color()
	else:
		AnswerButtons[pressed_index - 1].set("custom_colors/font_color", chosen_answer_color)


func set_answers_characters_shown(i:int):
	answers_characters_shown = i
	
	if AnswerButtons == null:
		return
	
	for b in AnswerButtons:
		b.visible_characters = i


func set_answers_disabled(b:bool):
	answers_disabled = b
	
	if AnswerButtons == null:
		return
	
	for b in AnswerButtons:
		b.disabled = answers_disabled


func set_current_upgrade(up:Upgrade):
	
	current_upgrade = up
	
	UpgradeIcon.texture = null
	UpgradeIcon.hint_tooltip = ""
	QuestionText.text = ""
	
	for b in AnswerButtons:
		b.answer = ""
		b.right_answer = false
		b.update_color()
	
	if current_upgrade != null:
		UpgradeIcon.texture = current_upgrade.get_texture()
		UpgradeIcon.hint_tooltip = current_upgrade.title
		QuestionText.text = current_upgrade.question
	
		var indexes := range(current_upgrade.wrong_answers.size() + 1)
		indexes.shuffle()
		
		for i in range(current_upgrade.wrong_answers.size()):
			AnswerButtons[indexes[i]].right_answer = false
			AnswerButtons[indexes[i]].answer = current_upgrade.wrong_answers[i]
		
		AnswerButtons[indexes.back()].right_answer = true
		AnswerButtons[indexes.back()].answer = current_upgrade.right_answer


func set_pressed_index(i:int):
	
	pressed_index = i
	
	if pressed_index == 0:
		return
	
	PlayerInventory.sub_upgrade(current_upgrade)
	
	state_machine.travel("Blink")
	AT.advance(0.0)
	
	if AnswerButtons[pressed_index - 1].right_answer:
		current_upgrade.upgraded_this_level = true
		current_upgrade.level += 1
		state_machine.travel("Accept")
	else:
		current_upgrade.level = 0
		state_machine.travel("Reject")
		Upgrades.push_front(current_upgrade)
		
	PlayerInventory.add_upgrade(current_upgrade)
	
	print(name + ".set_pressed_index(): in the end upgrade is ", Upgrades.size())


### updates ###
func set_next_up():
	
	pressed_index = 0
	
	if current_upgrade == null or Upgrades.empty():
		Upgrades = PlayerInventory.get_upgradable_upgrades()
	
	set_current_upgrade(null if Upgrades.empty() else Upgrades.pop_back())
	
	if current_upgrade != null:
		state_machine.travel("Shown")
	else:
		QuestionText.text = ALL_INVENTORIES_EMPTY_MSG \
				if PlayerInventory.empty() \
				else ALL_UPGRADES_DONE_MSG
		state_machine.travel("Error")


func set_up_null():
	set_current_upgrade(null)

#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
static func view_case_to_paused(vc:int) -> bool:
	return vc != SceneManager.Cases.UPGRADE_TABLE

### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####
#--# DATA METHODS #--#



#### GROUP METHODS ####

func on_view_case_change():
	
	var paused := view_case_to_paused(SceneManager.view_case)
	
	if visible == paused:
		reset()
	
	visible = not paused
	
	pause_mode = Node.PAUSE_MODE_STOP \
			if paused \
			else Node.PAUSE_MODE_INHERIT
	SceneManager.set_node_paused(self, paused)
	
	if visible:
		var s = name + " visible"
		if Upgrades.empty():
			s += " no ups"
			QuestionText.text = ALL_INVENTORIES_EMPTY_MSG \
					if PlayerInventory.empty() \
					else ALL_UPGRADES_DONE_MSG
			state_machine.travel("Error")
		
		else:
			s += " has ups"
			state_machine.travel("Hidden")

		print(s)
	#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####

func _on_Stop_button_down():
	state_machine.travel("Bring Down")


func _on_Start_button_down():
	set_next_up()

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
