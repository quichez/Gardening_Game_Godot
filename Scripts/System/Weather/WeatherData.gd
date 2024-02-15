class_name WeatherData

var date : Date = Date.new()

var temperature : int
var humidity : int
var cloud_cover : int

var weather_patterns_active = [false, false, false, false]
 
func get_temperature_as_string() -> String:
	return str(temperature) + "\u00B0F"
	
func get_temperature_in_celcius() -> int:
	return (temperature - 32) * 5 / 9
	
func get_temperature_in_kelvin() -> int:
	return get_temperature_in_celcius() + 273

func get_humidity_as_string() -> String:
	return str(humidity) + "%"
