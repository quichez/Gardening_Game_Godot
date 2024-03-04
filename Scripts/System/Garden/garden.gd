extends Node
const GARDEN_TILE = preload("res://Scripts/System/Garden/GardenTile.tscn")
@onready var grid_container: GridContainer = $GridContainer

@export_range(1,100) var x_dim : int
@export_range(1,100) var y_dim : int

func _ready() -> void:
	populate_garden_grid()
	
func populate_garden_grid() -> void:
	grid_container.columns = x_dim
	for i in x_dim:
		for j in y_dim:
			var garden_tile = GARDEN_TILE.instantiate()
			grid_container.add_child(garden_tile)
