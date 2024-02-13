extends Node

@onready var time: Node = $"../Time"

@export var selected_climate : ClimateData

@export var temperature : int
@export_range(0,100) var humidity: int
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

func _ready() -> void:
	initialize_forecast()
	set_weather()
	#time.weather_update.connect(set_weather)
	#time.date.day_updated.connect(check_for_weather_pattern)
	
#Pending Removal
func set_weather() -> void:
	season = full_forecast[0].season
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
	
	#Set random modifier to temperature and humidity
	temperature_mod += rng.randf_range(-0.01, 0.01)
	var random_mod_humid = rng.randi_range(-3,3)

	#Set the weather data
	weather_data.date = time.date
	weather_data.season = selected_climate.get_season_by_index(season_index)
	
	weather_data.temperature = weather_data.season.get_temperature_from_range(daytime_mod,temperature_mod + weather_pattern_temp_mod)
	weather_data.humidity = weather_data.season.get_humidity_from_range(daytime_mod,random_mod_humid + weather_pattern_humid_mod)
	weather_data.cloud_cover = 50
	
	#Set weather patterns 
	weather_data.weather_patterns_active = [false, false, false, false]
	
	return weather_data
	
func set_weather_pattern_data() -> Array[bool]:
	return [false, false, false, false]
	
func initialize_forecast() -> void:
	var forecast_count = 14 * 24 * (60 / time.increments_in_minutes)
	full_forecast.resize(forecast_count)
	
	for i in forecast_count:
		full_forecast[i] = set_weather_data()
		time.increment_time()

func increment_forecast() -> void:
	full_forecast.pop_front()
	full_forecast.append(set_weather_data())