extends Node

@onready var time: Node = $"../Time"

@export var selected_climate : ClimateData
var rng = RandomNumberGenerator.new()

#Current Weather
var temperature : int
var humidity: int
var temperature_mod : float
var season : Season

var weather_pattern_temp_mod : int
var weather_pattern_humid_mod : int

var heat_wave_active : bool
var cold_snap_active : bool
var rain_storm_active : bool
var drought_active : bool
var curr_weather_pattern = [0,0,0,0]

#Forecast System
var full_forecast : Array[WeatherData]


signal weather_updated(temperature: int, humidity: int, season: String)
signal weather_pattern_updated(pattern: String)
	
func set_current_weather() -> void:
	temperature = full_forecast[0].temperature
	humidity = full_forecast[0].humidity
	season = full_forecast[0].season
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
	weather_data.season = selected_climate.get_season_by_index(season_index)
	
	#Set random modifier to temperature and humidity
	temperature_mod += rng.randf_range(-0.01, 0.01)
	var random_mod_humid = rng.randi_range(-3,3)

	#Set the weather data
	weather_data.date.set_date(time.date)
	
	weather_data.temperature = weather_data.season.get_temperature_from_range(daytime_mod,temperature_mod + weather_pattern_temp_mod)
	weather_data.humidity = weather_data.season.get_humidity_from_range(daytime_mod,random_mod_humid + weather_pattern_humid_mod)
	weather_data.cloud_cover = 50
	
	return weather_data
	
func set_weather_pattern_data(curr_data : WeatherData, prev_data : WeatherData = null) -> void:
	var hw : float = rng.randf()
	var cs : float = rng.randf()
	var rs : float = rng.randf()
	var dt : float = rng.randf()
	var bool_array : Array[bool]= [false,false,false,false]
	
	if not prev_data:
		return
		
	if prev_data.weather_patterns_active[0]:
		bool_array[0] = hw < curr_data.season.get_chance_to_occur(curr_data.season.heat_wave_weight,0.01*curr_weather_pattern[0])
	else:
		bool_array[0] = hw < curr_data.season.get_chance_to_occur(curr_data.season.heat_wave_weight)
	if bool_array[0]:
		curr_weather_pattern[0] += 1
	else:
		curr_weather_pattern[0] = 0
		
	if prev_data.weather_patterns_active[1]:
		bool_array[1] = cs < curr_data.season.get_chance_to_occur(curr_data.season.cold_snap_weight,200.0/(curr_data.weather_pattern_counter[1]*10)) \
		&& curr_data.season.cold_snaps
	else:
		bool_array[1] = cs < curr_data.season.get_chance_to_occur(curr_data.season.cold_snap_weight) \
		&& curr_data.season.cold_snaps
	if bool_array[1]:
		curr_data.weather_pattern_counter[1] += 1
	else:
		curr_data.weather_pattern_counter[1] = 0
		
	if prev_data.weather_patterns_active[2]:
		bool_array[2] = rs < curr_data.season.get_chance_to_occur(curr_data.season.rain_storm_weight,200.0/(curr_data.weather_pattern_counter[2]*10)) \
		&& curr_data.season.rain_storms
	else:
		bool_array[2] = rs < curr_data.season.get_chance_to_occur(curr_data.season.rain_storm_weight)\
		 && curr_data.season.rain_storms
	if bool_array[2]:
		curr_data.weather_pattern_counter[2] += 1
	else:
		curr_data.weather_pattern_counter[2] = 0
			
	if prev_data.weather_patterns_active[3]:
		bool_array[3] = dt < curr_data.season.get_chance_to_occur(curr_data.season.drought_weight,200.0/(curr_data.weather_pattern_counter[3]*10)) \
		&& curr_data.season.droughts
	else:
		bool_array[3] = dt < curr_data.season.get_chance_to_occur(curr_data.season.drought_weight) \
		&& curr_data.season.droughts
	if bool_array[3]:
		curr_data.weather_pattern_counter[3] += 1
	else:	
		curr_data.weather_pattern_counter[3] += 1

	curr_data.weather_patterns_active = bool_array
	curr_data.weather_pattern_counter = curr_weather_pattern
		
##This method calls time.increment_time(), which can be refactored out if possible
func initialize_forecast() -> void:
	var forecast_count = 14 * 24 * (60 / time.increments_in_minutes)
	full_forecast.resize(forecast_count+1)
	for i in range(forecast_count+1):
		full_forecast[i] = set_weather_data()
		if i > 0:
			set_weather_pattern_data(full_forecast[i], full_forecast[i-1] )
		else:
			set_weather_pattern_data(full_forecast[i])
		time.increment_time()

##This method calls time.increment_time(), which can be refactored out if possible
func increment_forecast() -> void:
	full_forecast.remove_at(0)
	full_forecast.append(set_weather_data())
	set_weather_pattern_data(full_forecast[-1],full_forecast[-2])
	time.increment_time()
	pass

func get_forecast_estimate(forecast: Array[WeatherData]) -> Array[WeatherData]:
	var forecast_estimate : Array[WeatherData] = []
	
	
	forecast_estimate.resize(forecast.size())
	for i in forecast.size():
		if forecast[i].season.heat_waves:
			var max_guess = forecast[i].season.get_chance_to_occur(forecast[i].season.heat_wave_weight)
			#var guess_hw = clampf(rng.randf,0.0,forecast[i].season.get_chance_to_occur(\
				forecast[i].season.heat_wave_weight))
			forecast_estimate[i].weather_patterns_active[0] = true
		
	return forecast_estimate
