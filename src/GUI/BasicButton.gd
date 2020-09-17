tool
class_name BasicButton extends TextureButton


#### VARS ####
# enums
enum Types {LEFT, CENTER, RIGHT}

# consts
# settings
export(Types) var button_type:int = Types.RIGHT setget set_button_type
export(String) var text:String = "" setget set_text
export(Color) var text_color:Color = Utils.Colors.BLACK setget set_text_color
export(Color) var highlight_color:Color = Utils.Colors.LIGHT_YELLOW setget set_highlight_color
export(Color) var button_color:Color = Utils.Colors.DARK_GREEN setget set_button_color
export(Color) var pressed_button_color:Color = Utils.Colors.DARK_GREEN setget set_pressed_button_color
export(Color) var disabled_button_color:Color = Utils.Colors.DARK_GREEN setget set_disabled_button_color
export(Color) var contour_color:Color = Utils.Colors.BLACK setget set_contour_color
# singletons
# nodes
# public
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _ready():
	set_button_type(button_type)
	set_text(text)
	set_text_color(text_color)
	set_highlight_color(highlight_color)
	set_button_color(button_color)
	set_pressed_button_color(pressed_button_color)
	set_disabled_button_color(disabled_button_color)
	set_contour_color(contour_color)


func _activate():
	pass

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_disabled(b:bool):
	disabled = b
	pressed = false
	if not disabled and get_rect().has_point(get_viewport().get_mouse_position()):
		_on_Button_mouse_entered()
	else:
		_on_Button_mouse_exited()
	update_look(false)


func set_text(s:String):
	text = s
	
	if not is_inside_tree():
		return
	
	$contour/color/label.set_text(s)


func set_button_type(t:int):
	button_type = t
	
	if not is_inside_tree():
		return
	
	match button_type:
		Types.LEFT:
			$shadow.set_margin(MARGIN_LEFT, 1.0)
			$shadow.set_margin(MARGIN_TOP, 1.0)
			$shadow.set_margin(MARGIN_RIGHT, 0.0)
			$shadow.set_margin(MARGIN_BOTTOM, 0.0)
		
		Types.CENTER:
			$shadow.set_margin(MARGIN_LEFT, 0.0)
			$shadow.set_margin(MARGIN_TOP, 2.0)
			$shadow.set_margin(MARGIN_RIGHT, 0.0)
			$shadow.set_margin(MARGIN_BOTTOM, 0.0)
		
		Types.RIGHT:
			$shadow.set_margin(MARGIN_LEFT, 0.0)
			$shadow.set_margin(MARGIN_TOP, 1.0)
			$shadow.set_margin(MARGIN_RIGHT, -1.0)
			$shadow.set_margin(MARGIN_BOTTOM, 0.0)

	update_look(pressed)


func set_text_color(c:Color):
	text_color = c
	
	if not is_inside_tree():
		return
	
	$contour/color/label.set("custom_colors/font_color", c)


func set_highlight_color(c:Color):
	highlight_color = c
	
	if not is_inside_tree():
		return
	
	$contour/color/label.set_highlight_color(c)


func set_button_color(c:Color):
	button_color = c
	
	if not is_inside_tree():
		return
	
	$contour/color.color = c


func set_contour_color(c:Color):
	contour_color = c
	
	if not is_inside_tree():
		return
	
	$contour.color = c
	$shadow.color = c


func set_pressed_button_color(c:Color):
	pressed_button_color = c
	if is_pressed():
		$contour/color.color = c


func set_disabled_button_color(c:Color):
	disabled_button_color = c
	if is_disabled():
		$contour/color.color = c


### updates ###
func update_look(pressed:bool):
	
	if not is_inside_tree():
		return
	
	if disabled:
		$contour/color.color = disabled_button_color
		set_pressed_margin()
	elif pressed:
		$contour/color.color = pressed_button_color
		set_pressed_margin()
	else:
		$contour/color.color = button_color
		set_idle_margin()


func set_pressed_margin():
	
	if not is_inside_tree():
		return
	
	match button_type:
		Types.LEFT:
			$contour.set_margin(MARGIN_LEFT, 1.0)
			$contour.set_margin(MARGIN_TOP, 1.0)
			$contour.set_margin(MARGIN_RIGHT, 0.0)
			$contour.set_margin(MARGIN_BOTTOM, 0.0)
		
		Types.CENTER:
			$contour.set_margin(MARGIN_LEFT, 0.0)
			$contour.set_margin(MARGIN_TOP, 2.0)
			$contour.set_margin(MARGIN_RIGHT, 0.0)
			$contour.set_margin(MARGIN_BOTTOM, 0.0)
		
		Types.RIGHT:
			$contour.set_margin(MARGIN_LEFT, 0.0)
			$contour.set_margin(MARGIN_TOP, 1.0)
			$contour.set_margin(MARGIN_RIGHT, -1.0)
			$contour.set_margin(MARGIN_BOTTOM, 0.0)


func set_idle_margin():
	
	if not is_inside_tree():
		return
	
	match button_type:
		Types.LEFT:
			$contour.set_margin(MARGIN_LEFT, 0.0)
			$contour.set_margin(MARGIN_TOP, 0.0)
			$contour.set_margin(MARGIN_RIGHT, -1.0)
			$contour.set_margin(MARGIN_BOTTOM, -1.0)
		
		Types.CENTER:
			$contour.set_margin(MARGIN_LEFT, 0.0)
			$contour.set_margin(MARGIN_TOP, 0.0)
			$contour.set_margin(MARGIN_RIGHT, 0.0)
			$contour.set_margin(MARGIN_BOTTOM, -2.0)
		
		Types.RIGHT:
			$contour.set_margin(MARGIN_LEFT, 1.0)
			$contour.set_margin(MARGIN_TOP, 0.0)
			$contour.set_margin(MARGIN_RIGHT, 0.0)
			$contour.set_margin(MARGIN_BOTTOM, -1.0)

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

func _on_Button_mouse_entered():
	
	if not is_inside_tree():
		return
	
	if is_disabled():
		return
	
	$contour/color/label/highlight.visible = true
	$contour/color/label/left.visible = true
	$contour/color/label/top.visible = true
	$contour/color/label/right.visible = true
	$contour/color/label/bottom.visible = true


func _on_Button_mouse_exited():
	
	if not is_inside_tree():
		return
	
	$contour/color/label/highlight.visible = false
	$contour/color/label/left.visible = false
	$contour/color/label/top.visible = false
	$contour/color/label/right.visible = false
	$contour/color/label/bottom.visible = false


func _on_Button_button_down():
	update_look(true)


func _on_Button_button_up():
	_on_Button_mouse_exited()
	update_look(false)
	_activate()

#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
