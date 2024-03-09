extends Node
const GARDEN_TILE = preload("res://Scripts/System/Garden/GardenTile.tscn")

@onready var weather: Node = $"../Weather"
@onready var tile_map: TileMap = $TileMap

@export_range(1,100) var x_dim : int
@export_range(1,100) var y_dim : int

var tile_dict = {}
	
func initialize_garden() -> void:
	tile_dict = tile_map.initialize_grid(Vector2i(x_dim,y_dim))
	populate_garden_grid()
	
func get_camera_offset() -> Vector2i:
	return Vector2i(x_dim * 32, y_dim * 32)
	
func populate_garden_grid() -> void:
	pass

func update_garden_tiles() -> void:
	pass
	#for garden_tile in grid_container.get_children():
	#	garden_tile.update_tile_moisture_with_chance(weather.humidity, weather.rain_storm_active)

func add_row_to_garden() -> void:
	y_dim += 1
	tile_map.add_row_to_tile_map(Vector2i(x_dim,y_dim))
