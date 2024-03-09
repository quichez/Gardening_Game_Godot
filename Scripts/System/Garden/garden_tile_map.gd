extends TileMap

signal on_garden_size_update

func initialize_grid(dimensions : Vector2i) -> Dictionary:
	var dic = {}
	for x in dimensions.x:
		for y in dimensions.y:
			set_cell(0,Vector2i(x,y),0,Vector2i(0,0),0)
			dic[str(Vector2(x,y))] = GardenTileData.new()
	on_garden_size_update.emit()
	return dic

func add_row_to_tile_map(dimensions: Vector2i) -> Dictionary:
	var dic = {}
	for x in dimensions.x:
		set_cell(0,Vector2i(x,dimensions.y),0,Vector2i(0,0),0)
		dic[str(Vector2i(x,dimensions.y))] = GardenTileData.new()
	on_garden_size_update.emit()
	return dic
	
