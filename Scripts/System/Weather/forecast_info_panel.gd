extends Node
@onready var date: Label = $Date
@onready var temperature: Label = $Temperature
@onready var humidity: Label = $Humidity
@onready var cloudy: Label = $Cloudy


func set_forecast_info_panel(weather: WeatherData, level : int) -> void:
	if level == 1 or level == 2:
		date.text = weather.date.get_time_as_string(false)
	else:
		date.text = weather.date.get_day_month_as_string(false)
	temperature.text = weather.get_temperature_as_string()
	humidity.text = weather.get_humidity_as_string()
	cloudy.text = ""
