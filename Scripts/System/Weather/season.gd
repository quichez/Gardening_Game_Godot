extends Resource
class_name Season

enum TempDesc {Hot, Warm, Moderate, Cool, Cold}
enum PrecDesc {Heavy, Moderate, Arid}
enum HumidDesc {Humid, Moderate, Dry}
enum DailyVarDesc {Swings, Fluctuates, Steady}

@export var season_name : String

## The average daily low/high temperatures. X is low, Y is high.
@export var daily_temperature_range : Vector2
@export var daily_humidity_range : Vector2

@export_group("Enable Weather Patterns")
@export var heat_waves : bool
@export var cold_snaps : bool
@export var rain_storms : bool
@export var droughts : bool 

@export_range(0,1) var heat_wave_weight : float
@export_range(0,1) var cold_snap_weight : float
@export_range(0,1) var rain_storm_weight : float
@export_range(0,1) var drought_weight : float

func get_temperature_from_range(lerp_float: float, random_mod: float) -> int:
	return round(lerp(daily_temperature_range.x, daily_temperature_range.y, lerp_float) + random_mod)

func get_humidity_from_range(lerp_float: float, random_mod: float) -> int:
	return clampi(lerp(daily_humidity_range.x, daily_humidity_range.y,lerp_float) + random_mod,0,100)

func get_chance_to_occur(input_value: float, input_threshold : float = 500.0) -> float:
	var max_output = 1.0
	var output = max_output * (1.0 - 1.0 / (1.0 + input_value / input_threshold))
	output = clamp(output, 0.0, 1.0)
	return output
