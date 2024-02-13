class_name WeatherData

var date : Date = Date.new()
var season : Season

var temperature : int
var humidity : int
var cloud_cover : int

var weather_patterns_active = [false, false, false, false]
 
func get_temperature_in_celcius() -> int:
	return (temperature - 32) * 5 / 9
	
func get_temperature_in_kelvin() -> int:
	return get_temperature_in_celcius() + 273
