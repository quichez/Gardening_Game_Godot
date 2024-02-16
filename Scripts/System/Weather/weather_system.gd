extends Node

@onready var time: Node = $"../Time"

@export var selected_climate : ClimateData

var temperature : int
var humidity: int
var temperature_mod : float

var rng = RandomNumberGenerator.new()

var season : Season

var weather_pattern_temp_mod : int
var weather_pattern_humid_mod : int
var heat_wave_active : bool
var cold_snap_active : bool
var rain_storm_active : bool
var drought_active : bool
var full_forecast : Array[WeatherData]

signal weather_updated(temperature: int, humidity: int, season: String)
signal weather_pattern_updated(pattern: String)
	
func set_current_weather() -> void:
	temperature = full_forecast[0].temperature
	humidity = full_forecast[0].humidity
	
	weather_updated.emit(temperature, humidity, season.season_name)

#Pending Removal/Rework
func check_for_weather_pattern() -> void:
	var rng_weather_pattern = RandomNumberGenerator.new()
	
	#Check to see if any pattern is active and roll to continue
	if heat_wave_active or cold_snap_active:
		var end_temp_pattern = rng_weather_pattern.randf()
		if end_temp_pattern < 0.33:
			full_forecast.back().weather_patterns_active[0] = false
			full_forecast.back().weather_patterns_active[1] = false
			weather_pattern_temp_mod = 0
			#weather_pattern_updated.emit("")
		return
	if rain_storm_active:
		var end_rain = rng_weather_pattern.randf()
		if end_rain < 0.4:
			full_forecast.back().weather_patterns_active[2] = false
			weather_pattern_humid_mod = 0
			#weather_pattern_updated.emit("")
		return
	if drought_active:
		var end_drought = rng_weather_pattern.randf()
		if end_drought < 0.2:
			full_forecast.back().weather_patterns_active[3] = false
			weather_pattern_humid_mod = 0
			#weather_pattern_updated.emit("")
		return
	
	#Check if patterns are available and roll to begin
	if full_forecast.back().season.heat_waves:
		var start_heat_wave = rng_weather_pattern.randf()
		if start_heat_wave < full_forecast.back().season.daily_chance_to_occur:
			full_forecast.back().weather_patterns_active[0] = true
			weather_pattern_temp_mod = 10
			#weather_pattern_updated.emit("It's hot out!")
			
	if full_forecast.back().season.cold_snaps:
		var start_cold_snaps = rng_weather_pattern.randf()
		if start_cold_snaps < season.daily_chance_to_occur:
			full_forecast.back().weather_patterns_active[1] = true
			weather_pattern_temp_mod = -10
			#weather_pattern_updated.emit("It's freezing!")
			
	if full_forecast.back().season.rain_storms:
		var start_rain_storm = rng_weather_pattern.randf()
		if start_rain_storm < season.daily_chance_to_occur:
			full_forecast.back().weather_patterns_active[2] = true
			weather_pattern_humid_mod = 20
			weather_pattern_temp_mod = -5
			#weather_pattern_updated.emit("It's raining!")
			
	if full_forecast.back().season.droughts:
		var start_drought = rng_weather_pattern.randf()
		if start_drought < season.daily_chance_to_occur:
			full_forecast.back().weather_patterns_active[3] = true
			weather_pattern_humid_mod = -20
			#weather_pattern_updated.emit("It's dry as bones!")

func set_weather_data() -> WeatherData:
	var weather_data = WeatherData.new()
	
	#Get percentage through year and time of day
	var pct_of_year = time.date.get_percentage_through_year()
	var daytime_mod = (-1.0 * abs(-1.0 * time.date.get_percentage_through_day() + 0.5) + 0.5) * 2.0
	
	#Get current season index
	var season_index = selected_climate.get_season_index(pct_of_year)
	season = selected_climate.get_season_by_index(season_index)
	
	#Set random modifier to temperature and humidity
	temperature_mod += rng.randf_range(-0.01, 0.01)
	var random_mod_humid = rng.randi_range(-3,3)

	#Set the weather data
	weather_data.date.set_date(time.date)
	
	weather_data.temperature = season.get_temperature_from_range(daytime_mod,temperature_mod + weather_pattern_temp_mod)
	weather_data.humidity = season.get_humidity_from_range(daytime_mod,random_mod_humid + weather_pattern_humid_mod)
	weather_data.cloud_cover = 50
	
	#Set weather patterns 
	weather_data.weather_patterns_active = [false, false, false, false]
	
	return weather_data
	
func set_weather_pattern_data() -> Array[bool]:
	return [false, false, false, false]
	
##This method calls time.increment_time(), which can be refactored out if possible
func initialize_forecast() -> void:
	var forecast_count = 14 * 24 * (60 / time.increments_in_minutes)
	full_forecast.resize(forecast_count+1)
	for i in range(forecast_count+1):
		full_forecast[i] = set_weather_data()
		time.increment_time()

##This method calls time.increment_time(), which can be refactored out if possible
func increment_forecast() -> void:
	full_forecast.remove_at(0)
	full_forecast.append(set_weather_data())
	time.increment_time()
	pass

func get_forecast(level: int) -> Array[WeatherData]:
	var interval : int
	var forecast : Array[WeatherData]
	var forecast_count : int
	
	match level:
		1:
			forecast_count = 12
			interval = 60 / time.increments_in_minutes
		2:
			forecast_count = 12
			interval = 60 / time.increments_in_minutes * 2
		3:
			forecast_count = 7
			interval = 60 / time.increments_in_minutes * 24
		4:
			forecast_count = 14
			interval = 60 / time.increments_in_minutes * 24
		_:
			push_error("Level needs to be 1 to 4")
	
	forecast.resize(forecast_count)
	for i in forecast_count:
		forecast[i] = full_forecast[(i+1)*interval]
			
	return forecast

func get_forecast_estimate(forecast: Array[WeatherData]) -> Array[WeatherData]:
	var forecast_estimate : Array[WeatherData] = forecast
	for i in forecast.size():
		forecast_estimate[i].weather_patterns_active[0] = true
		
	return forecast_estimate
