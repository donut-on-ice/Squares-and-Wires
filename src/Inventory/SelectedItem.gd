class_name SelectedItem extends TextureRect

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
var upgrade:Upgrade = null setget set_upgrade

# public
var hot_spot:Vector2 = Vector2.ZERO setget set_hot_spot

# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _input(event:InputEvent):
	
	if not visible:
		return
	
	if not event is InputEventMouseMotion:
		return

	set_global_position(get_global_mouse_position() - hot_spot)
	
	
#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
func set_upgrade(up:Upgrade):
	upgrade = up
	
	visible = upgrade != null
	
	if visible:
		set_global_position(get_global_mouse_position() - hot_spot)
		set_texture(Upgrade.IconTextures[upgrade.type])


func set_hot_spot(v2:Vector2):
	hot_spot = v2
	set_global_position(get_global_mouse_position() - hot_spot)

### updates ###
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
