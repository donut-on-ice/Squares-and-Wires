class_name Time extends Resource

#### VARS ####
# enums
# consts
# settings
# singletons
# nodes
# public
var year:int		# YYYY
var month:int		# 01-12
var day:int			# 01-31

var hour:int		# 00-23
var minute:int		# 00-59
var second:int		# 00-59

var utc_bias:int	# 100 - hour , 1 - minute, [+/-] - above or below +000
# private
# signals
#--# VARS #--#



#### MAIN METHODS ####

func _init(empty:bool = false):
	
	if empty:
		return
	
	var t = OS.get_datetime()
	var tz = OS.get_time_zone_info()
	
	year = t.year
	month = t.month
	day = t.day
	
	hour = t.hour
	minute = t.minute
	second = t.second
	
	utc_bias = tz.bias
	
	
func _to_string():
	return "%02d.%02d.%d %02d:%02d:%02d UTC %+03d" \
			% [day, month, year, hour, minute, second, utc_bias]

#--# MAIN METHODS #--#



#### STATE CHANGING METHODS ####
### setters ###
### updates ###
#--# STATE CHANGING METHODS #--#



#### NON STATE CHANGING METHODS ####
### gets ###
### bools ###
### utils ###
#--# NON STATE CHANGING METHODS #--#



#### DATA METHODS ####

func to_data() -> Dictionary:
	return {
		"year": year,
		"month": month,
		"day": day,
		
		"hour": hour,
		"minute": minute,
		"second": second,
		
		"utc_bias": utc_bias
	}

func from_data(data:Dictionary):
	
	year = data.year
	month = data.month
	day = data.day
	
	hour = data.hour
	minute = data.minute
	second = data.second
	
	utc_bias = data.bias
	

#--# DATA METHODS #--#



#### GROUP METHODS ####
#--# GROUP METHODS #--# 



#### SIGNAL METHODS ####
#--# SIGNAL METHODS #--# 



#### CLASSES ####
#--# CLASSES #--#
