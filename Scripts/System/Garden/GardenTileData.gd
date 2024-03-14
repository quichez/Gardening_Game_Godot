class_name GardenTileData

var x_pos : int
var y_pos : int
var age : int = 0
var moisture : float = 0.5

#Soil Nutrients - NPK
var nitrogen : float = 0.5
var phosphorus : float = 0.5
var potassium : float = 0.5

#Soil Nutrients - Major
var magnesium : float = 0.5
var calcium : float = 0.5
var sulfur : float = 0.5

#Soil Nutrients - Trace
var copper : float = 0.5
var manganese : float = 0.5
var iron : float = 0.5
var molybdenum : float = 0.5
var zinc : float = 0.5
var chlorine : float = 0.5
var boron : float = 0.5

#Soil Attributes
var retention : float = 0.5

#this is going to need comments, even I don't know why I wrote it this way
func update_tile_moisture_with_chance(humidity: float, rain_storm : bool) -> void:
	#If raining, big increase in moisture
	if rain_storm:
		change_moisture(0.03)
	#Otherwise, determine level of moisture change
	else:
		var rng = RandomNumberGenerator.new()
		#roll for retention! high retention means humidity doesn't change (should go up though, fix that later)
		if rng.randf() > retention:
			var humidity_difference : float = (humidity - 100.0)/100.0 - rng.randf_range(0.1,0.3)
			if humidity_difference < 50.0:
				humidity_difference *= 2.0
			else:
				humidity_difference *= 0.75
			change_moisture(clampf(humidity_difference/1000.0,-1.0,1.0))

func change_moisture(amount : float) -> void:
	moisture = clampf(moisture + amount, 0.0, 1.0)

func water_tile(watering_strength : Constants.WateringStrength) -> void:
	pass

func fertilize_tile(nutrient : Constants.SoilNutrient, amount : float) -> void:
	pass
