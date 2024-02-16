extends Resource
class_name ClimateData

@export var climate_name: String
@export var seasons : Array[Season]
#@export var info_file : String
@export_file("*.txt") var info_file

func get_season_index(pct_of_year: float) -> int:
	return mini(floori(pct_of_year * float(seasons.size())),seasons.size()-1)
	
func get_season_by_index(index: int) -> Season:
	return seasons[index]

func get_info_file() -> String:
	var f = FileAccess.open(info_file,FileAccess.READ)
	var content = ""
	if f:
		content = f.get_as_text()
	return content
	
