extends Node
const forecast_info_panel = preload("res://forecast_info_panel.tscn")

@onready var weather: Node = $"../../Weather"
@onready var h_box_container: HBoxContainer = $VBoxContainer/ScrollContainer/HBoxContainer
@onready var forecast_label: Label = $VBoxContainer/ForecastLabelPanel/ForecastLabel
@onready var button: Button = $VBoxContainer/ForecastLabelPanel/Button
@onready var time: Node = $"../../Time"

var current_forecast_detail : int = 1
var forecast_detail_counter : int = 0
var current_forecast : Array[WeatherData]

var forecast_level_one : Array[WeatherData]
var forecast_level_two : Array[WeatherData]
var forecast_level_three : Array[WeatherData]
var forecast_level_four : Array[WeatherData]

signal change_forecast_detail_level()

func set_forecast_panel(forecast: Array[WeatherData], update_counter: bool) -> void:
	var fc = get_forecast(forecast,update_counter)
	
	for child in h_box_container.get_children():
		child.queue_free()
				
	for i in fc.size():
		var panel = forecast_info_panel.instantiate()
		h_box_container.add_child(panel)
		panel.set_forecast_info_panel(fc[i], current_forecast_detail)
		match current_forecast_detail:
			1:
				forecast_label.text = "Forecast: 12-Hour"
			2:
				forecast_label.text = "Forecast: 24-Hour"
			3:
				forecast_label.text = "Forecast: 1 Week"
			4:
				forecast_label.text = "Forecast: 2 Week"
					
func on_change_forecast_pressed() -> void:
	current_forecast_detail += 1
	if current_forecast_detail == 5:
		current_forecast_detail = 1
	change_forecast_detail_level.emit()	
	
func get_forecast(full_forecast : Array[WeatherData],update_counter: bool) -> Array[WeatherData]:
	var interval : int = 60 / time.increments_in_minutes
	
	if not (forecast_level_one && forecast_level_two && forecast_level_three && forecast_level_four):
		forecast_level_one = set_forecast(full_forecast,12,interval)
		forecast_level_two = set_forecast(full_forecast,12,interval*2)
		forecast_level_three = set_forecast(full_forecast,7,interval*24)
		forecast_level_four = set_forecast(full_forecast,14,interval*24)
		
	if update_counter:
		forecast_detail_counter += 1
		if forecast_detail_counter == 96:
			forecast_detail_counter = 0
	
	if forecast_detail_counter % 4 == 0:
				forecast_level_one = set_forecast(full_forecast,12,interval)
	if forecast_detail_counter % 8 == 0:
				forecast_level_two = set_forecast(full_forecast,12,interval*2)
	if forecast_detail_counter % 96 == 0:
				forecast_level_three = set_forecast(full_forecast,7,interval*24)
	if forecast_detail_counter % 96 == 0:
				forecast_level_four = set_forecast(full_forecast,14,interval*24)
	
	match current_forecast_detail:
		1:
			return forecast_level_one
		2:
			return forecast_level_two
		3:
			return forecast_level_three
		4:
			return forecast_level_four
		_:
			push_error("Level needs to be 1 to 4")
		
	return current_forecast	
	
func set_forecast(full_forecast: Array[WeatherData], forecast_count: int, interval: int) -> Array[WeatherData]:
	var forecast : Array[WeatherData]
	forecast.resize(forecast_count)
	for i in forecast_count:
		forecast[i] = full_forecast[(i+1)*interval]
	return forecast
