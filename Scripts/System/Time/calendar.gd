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

signal current_date_updated(date : String)
signal weather_update

var date : Date = Date.new()
var current_date : Date = Date.new()
	
func initialize_time() -> void:
	date.set_date_with_ints(start_day, start_month, start_year)
	current_date.set_date(date)
	
	timer.autostart = true
	timer.wait_time = length_of_day / (4.0*24.0)

	current_date_updated.emit(current_date.get_date_as_string(date_with_day_first))
	
func set_current_time(_date: Date) -> void:
	current_date.set_date(_date)
	current_date_updated.emit(current_date.get_date_as_string(date_with_day_first))

func increment_time() -> void:
	date.increment(increments_in_minutes)
