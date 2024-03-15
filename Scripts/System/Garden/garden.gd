extends Node
const GARDEN_TILE = preload("res://Scripts/System/Garden/GardenTile.tscn")

@onready var weather: Node = $"../Weather"
@onready var tile_map: TileMap = $TileMap
@onready var garden_tile_inspector: Control = $"../UI/GardenTileInspector"

@export_range(1,100) var x_dim : int
@export_range(1,100) var y_dim : int

var tile_dict = {}
var dims : Vector2i = Vector2i(x_dim,y_dim)
	
func initialize_garden() -> void:
	tile_dict = tile_map.initialize_grid(Vector2i(x_dim,y_dim))
	populate_garden_grid()
	
func get_camera_offset() -> Vector2i:
	return Vector2i(x_dim * 32, y_dim * 32)
	
func populate_garden_grid() -> void:
	pass

func update_garden_tiles() -> void:
	for garden_tile in tile_dict:
		tile_dict[garden_tile].update_tile_moisture_with_chance(weather.humidity, weather.rain_storm_active)
		tile_map.update_garden_tile_map(tile_dict[garden_tile])

func add_row_to_garden() -> void:
	y_dim += 1
	tile_map.add_row_to_tile_map(dims)

func add_column_to_garden() -> void:
	x_dim += 1
	tile_map.add_column_to_tile_map(dims)

func check_for_selected_garden_tile() -> void:
	var tile = tile_map.get_tile(tile_dict)
	
	if tile:
		garden_tile_inspector.show()
		if Input.is_action_pressed("Modify"):
			garden_tile_inspector.show_nutrients(true)	
		else:
			garden_tile_inspector.show_nutrients(false)	
		garden_tile_inspector.set_inspector(tile)
	else:
		garden_tile_inspector.hide()


func _process(delta):
	check_for_selected_garden_tile()
