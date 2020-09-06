class_name Point extends Resource

var x:int = 0
var y:int = 0


func _init(rx:int = 0, ry:int = 0) -> void:
	x = rx
	y = ry

	
func _str() -> String:
	return "[" + str(x) + ", " + str(y) +"]" 


func to_v2() -> Vector2:
	return Vector2(x, y)


func to_data() -> Dictionary:
	return {"x": x, "y": y}
	

func from_data(d:Dictionary) -> void:
	x = d["x"]
	y = d["y"]
