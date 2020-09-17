extends Node

enum CollisionLayers {
		BLOCKS_PATH = 1 << 0, 
		BLOCKS_SIGHT = 1 << 1,
		INTERACTABLES = 1 << 2,
		
		
		PLAYER_HURT = 1 << 5,
		ROBO_HURT = 1 << 6,
		BEETALO_HURT = 1 << 7,
		CATERPILLAR_HURT = 1 << 8,
		
		STATIC_BLOCKS_PATH = 1 << 10,
		STATIC_BLOCKS_SIGHT = 1 << 11,
		STATIC_INTERACTABLES = 1 << 12
	}

const ZERO := 0.001
const INT_BITS := 64

const Colors := {
		BLACK = Color("0c0817"),
		DARK_GREEN = Color("0b2b3b"),
		LIGHT_RED = Color("ff5980"),
		LIGHT_GREEN = Color("a2ff99"),
		LIGHT_BLUE = Color("7ad5ff"),
		LIGHT_YELLOW = Color("ffee83"),
		MENU_LIGHT_BLUE = Color("5c81bd"),
		MENU_BLUE = Color("4756a1"),
		MENU_DARK_BLUE = Color("1c1452"),
	}


static func get_control_true_scale(c:Control) -> Vector2:
	return c.rect_scale * (get_control_true_scale(c.get_parent()) \
							if c.get_parent() != null and c.get_parent() is Control
							else Vector2.ONE)


static func clamp_int(value:int, minim:int, maxim:int) -> int:
	return minim if value < minim else maxim if maxim < value else value 


static func randi_range(from:int, to:int) -> int:
	var a = randi()
	return a % (to - from + 1) + from


static func min_int(a:int, b:int):
	return a if a < b else b


static func max_int(a:int, b:int):
	return a if a > b else b


static func set_all_children_owner(n:Node, o:Node):
	
	if n != o:
		n.owner = o
	
	if n.filename != null and n.filename != "":
		return
	
	for c in n.get_children():
		set_all_children_owner(c, o)


static func get_date_as_string() -> String:

	var t = OS.get_datetime()
	var tz = OS.get_time_zone_info()
	
	return "%02d.%02d.%d %02d:%02d:%02d UTC %s" \
			% [t.day, t.month, t.year, t.hour, t.minute, t.second, tz.bias]


static func pixel_perfect_cicle(center:Vector2, radius:float) -> PoolVector2Array:
	
	var circle := PoolVector2Array() 

	if radius <= 0:
		circle.append(Vector2(center.x, center.y))
		return circle
		 
	var v := Vector2(center.x + radius, center.y)
	var rs := (radius) * (radius)
	
	var ii
	var iii
	var iiii
	var iiiii
	var iiiiii
	var iiiiiii
	var iiiiiiii
	
	
	var cc := []
		
	while abs(v.x - v.y) > 1:
		var v0 = Vector2(v.x, v.y)
		var v1 = Vector2(v.x-1, v.y)
		
		if abs(v0.length_squared() - rs) > abs(v1.length_squared() - rs):
		
			cc.append(v1)
			v = Vector2(v1.x, v1.y+1)
		
		else:
		
			cc.append(v0)
			v = Vector2(v0.x, v0.y+1)
	
	var length := (cc.size() * 2 - 1) * 4
	
	if abs(cc.back().x - cc.back().y) == 2:
		cc.append(Vector2(v.x - 1, v.y))
		length =  (cc.size() - 1) * 8
	
	circle.resize(length)
	
	for i in range(cc.size()):
		ii = length * 1/4 - i 
		iii = length * 1/4 + i 
		iiii = length * 1/2 - i 
		iiiii = length * 1/2 + i 
		iiiiii = length * 3/4 - i
		iiiiiii = length * 3/4 + i
		iiiiiiii = (length - i) % length
		
		v = cc[i]
		
		circle.set(i, Vector2(v.x, v.y))
		circle.set(ii, Vector2(v.y, v.x))
		circle.set(iii, Vector2(-v.y, v.x))
		circle.set(iiii, Vector2(-v.x, v.y))
		circle.set(iiiii, Vector2(-v.x, -v.y))
		circle.set(iiiiii, Vector2(-v.y, -v.x))
		circle.set(iiiiiii, Vector2(v.y, -v.x))
		circle.set(iiiiiiii, Vector2(v.x, -v.y))
	
	return circle


static func upgrade_from_data(data:Dictionary) -> Upgrade:

	var ret:Upgrade
	
	if not data.has("type"):
		ret = Upgrade.new()
	else:
		match data.type:
			Upgrade.Types.HEALTH: ret = Upgrade.new() # TODO
			Upgrade.Types.SPEED: ret = Upgrade.new() # TODO
			Upgrade.Types.DAMAGE: ret = Upgrade.new() # TODO
			Upgrade.Types.PROTECTION: ret = Upgrade.new() # TODO
			Upgrade.Types.UTILITY: ret = Upgrade.new() # TODO
			_: ret = Upgrade.new()
			
	ret.from_data(data)
	return ret


static func ability_from_data(data:Dictionary) -> Ability:

	var ret:Ability
	
	if not data.has("type"):
		ret = Ability.new()
	else:
		match data.type:
			Ability.Types.DASH: ret = Ability.new() # TODO
			Ability.Types.BLINK: ret = Ability.new() # TODO
			Ability.Types.ATTACK: ret = Attack.new()
			Ability.Types.HEAL: ret = Ability.new() # TODO
			Ability.Types.CHARGE: ret = Ability.new() # TODO
			_: ret = Ability.new()
			
	ret.from_data(data)
	return ret


# rotates left first "size" bits of "rotated" by "how_much' amount
static func rotate_bits_left(rotated:int, how_much:int, size:int) -> int:
	#var UNCHANGED_MASK:int = ~0 << size 
	var MASK = ~(~0 << size)
	var changed:int = MASK & rotated
	#var uncahnged:int = UNCHANGED_MASK & rotated
	var left:int = changed << how_much
	var right:int = changed >> (size - how_much)
	#return uncahnged | left | right
	return (left | right) & MASK


# rotates right first "size" bits of "rotated" by "how_much' amount
static func rotate_bits_right(rotated:int, how_much:int, size:int) -> int:
	#var UNCHANGED_MASK:int = ~0 << size 
	var MASK = ~(~0 << size)
	var changed:int = MASK & rotated
	#var uncahnged:int = UNCHANGED_MASK & rotated
	var left:int = changed << (size - how_much)
	var right:int = changed >> how_much
	#return uncahnged | left | right
	return (left | right) & MASK
