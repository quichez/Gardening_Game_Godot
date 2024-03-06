extends Node

var tile_data : GardenTileData
var position : Vector2i

func _ready() -> void:
	tile_data = GardenTileData.new()

func update_tile_moisture_with_chance(humidity: float, rain_storm : bool) -> void:
	if rain_storm:
		change_moisture(0.03)
	else:
		var rng = RandomNumberGenerator.new()
		if rng.randf() > tile_data.retention:
			var humidity_difference : float = (humidity/100.0 - tile_data.moisture)/(humidity/100.0) - rng.randf_range(0.1,0.3)
			if humidity_difference < 0:
				humidity_difference *= 2.0
			change_moisture(clampf(humidity_difference/1000.0,-1.0,1.0))
		
	
func change_moisture(amount : float) -> void:
	tile_data.moisture = clampf(tile_data.moisture + amount, 0.0, 1.0)
