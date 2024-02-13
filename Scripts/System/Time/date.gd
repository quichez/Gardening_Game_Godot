class_name Date

#Julian Day is day counter for entire year - used for year-long calculations
var julian_day : int

var day : int
var month : int
var year : int

var hour : int
var minute : int

signal day_updated()
signal month_updated()
signal year_updated()

func _init() -> void:
	julian_day = 1
	
	day = 1
	month = 1
	year = 1
	hour = 6
	minute = 0
	
func set_date(date: Date) -> void:
	day = date.day
	month = date.month
	year = date.year
	
	julian_day = (month-1) * 30 + day
	
func set_date_with_ints(day_int: int, month_int: int, year_int: int) -> void:
	day = day_int
	month = month_int
	year = year_int
	
	julian_day = (month-1) * 30 + day
	
func get_date_as_string(day_first: bool, twentyfour_hour : bool = false) -> String:
	if day_first:
		return str(day) + "/" + str(month) + "/" + "%04d" % year + " \t" + get_time_as_string(twentyfour_hour)
	else:
		return  str(month) + "/" + str(day) + "/" +"%04d" % year + " \t" + get_time_as_string(twentyfour_hour)

func get_time_as_string(twentyfour_hour : bool):
	if twentyfour_hour:
		return str(hour) + ":" + "%02d" % minute
	elif hour > 12:
		return str(hour-12) + ":" + "%02d" % minute + " PM"
	elif hour == 12:
		return str(hour) + ":" + "%02d" % minute + " PM"
	elif hour == 0: 
		return str(12) + ":" + "%02d" % minute + " AM"
	else:
		return str(hour) + ":" + "%02d" % minute + " AM"

func increment(delta: int = 15) -> void:
	minute += delta
	if minute == 60:
		hour += 1
		minute = 0
	if hour == 24:
		hour = 0
		day += 1
		julian_day += 1
		day_updated.emit()

	if(day == 31):
		month += 1
		day = 1
		month_updated.emit()
	
	if(month == 13):
		year += 1
		month = 1
		day = 1
		julian_day = 1
		year_updated.emit()

func get_percentage_through_day() -> float:
	return hour / 24.0
	
func get_percentage_through_year() -> float:
	return float(julian_day) / 360.0
