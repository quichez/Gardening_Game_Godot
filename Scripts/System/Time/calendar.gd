extends Node
@export_category("Time Settings")
@export var length_of_day : int
@export_range(10,60) var increments_in_minutes : int
@export var date_with_day_first : bool = true

@export_subgroup("Start Date")
@export_range(1,30) var start_day : int
@export_range(1,12) var start_month : int
@export_range(2000,9999) var start_year : int

@onready var timer: Timer = $Timer

signal date_updated(date : String)
signal weather_update

var date : Date = Date.new()
	
func initialize_time() -> void:
	date.set_date_with_ints(start_day, start_month, start_year)
	timer.autostart = true
	timer.wait_time = length_of_day / (4.0*24.0)

	date_updated.emit(date.get_date_as_string(date_with_day_first))
	
func set_current_time(_date: Date) -> void:
	date = _date
	date_updated.emit(date.get_date_as_string(date_with_day_first))

func increment_time() -> void:
	date.increment(increments_in_minutes)
	print(date.get_time_as_string(false))

func get_date() -> Date:
	return date
