extends Node

var tile_data : GardenTileData
var position : Vector2i

func _ready() -> void:
	tile_data = GardenTileData.new()
	
func change_moisture(amount : float) -> void:
	tile_data.moisture = clampf(tile_data.moisture + amount, 0.0, 1.0)
