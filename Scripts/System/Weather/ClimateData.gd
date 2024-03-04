extends Resource
class_name ClimateData

@export var climate_name: String
@export var seasons : Array[Season]
#@export var info_file : String
@export_file("*.txt") var info_file

func get_season_index(pct_of_year: float) -> int:
	return mini(floori(pct_of_year * float(seasons.size())),seasons.size()-1)
	
func get_season_by_index(index: int) -> Season:
	check_season_validity(seasons[index])
	return seasons[index]

func get_info_file() -> String:
	if not info_file:
		push_error("ClimateData has no valid Info File")
	var f = FileAccess.open(info_file,FileAccess.READ)
	var content = ""
	if f:
		content = f.get_as_text()
	return content
	
func check_season_validity(season: Season) -> void:
	if season.heat_waves && season.cold_snaps:
		push_error("Season can't be prone to heat wave and cold snaps")
	if season.rain_storms && season.droughts:
		push_error("Season can't be prone to rainstorms and droughts")
	if not season.heat_waves && season.heat_wave_weight != 0.0 || \
		not season.cold_snaps && season.cold_snap_weight != 0.0 || \
		not season.rain_storms && season.rain_storm_weight != 0.0 || \
		not season.droughts && season.drought_weight != 0.0:
		push_warning("Season can't have a non-zero weight for inactive patterns.")
