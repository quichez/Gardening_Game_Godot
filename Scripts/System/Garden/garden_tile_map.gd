extends TileMap

signal on_garden_size_update
var GridSize : Vector2i
func initialize_grid(dimensions : Vector2i) -> Dictionary:
	var dic = {}
	GridSize = dimensions
	for x in dimensions.x:
		for y in dimensions.y:
			set_cell(0,Vector2i(x,y),0,Vector2i(0,0),0)
			dic[str(Vector2(x,y))] = GardenTileData.new()
			dic[str(Vector2(x,y))].x_pos = x
			dic[str(Vector2(x,y))].y_pos = y
	on_garden_size_update.emit()
	return dic

func add_row_to_tile_map(dimensions: Vector2i) -> Dictionary:
	var dic = {}
	for x in dimensions.x:
		set_cell(0,Vector2i(x,dimensions.y),0,Vector2i(0,0),0)
		dic[str(Vector2i(x,dimensions.y))] = GardenTileData.new()
	on_garden_size_update.emit()
	return dic
	
func update_garden_tile_map(tile_data : GardenTileData) -> void:
	update_garden_tile_moisture(tile_data)
	
func update_garden_tile_moisture(tile_data : GardenTileData) -> void:
	if tile_data.moisture < 0.2:
		set_cell(0,Vector2i(tile_data.x_pos, tile_data.y_pos),0,Vector2i(0,0))
	elif tile_data.moisture < 0.4: 
		set_cell(0,Vector2i(tile_data.x_pos, tile_data.y_pos),0,Vector2i(1,0))
	elif tile_data.moisture < 0.6: 
		set_cell(0,Vector2i(tile_data.x_pos, tile_data.y_pos),0,Vector2i(0,1))
	else:
		set_cell(0,Vector2i(tile_data.x_pos, tile_data.y_pos),0,Vector2i(1,1))
	pass

func get_tile(tile_dict: Dictionary) -> void:
	var tile = local_to_map(get_global_mouse_position())
	for x in GridSize.x:
		for y in GridSize.y:
			erase_cell(1,Vector2i(x,y))
			
	if tile_dict.has(str(tile)):
		set_cell(1,Vector2i(tile.x,tile.y),1,Vector2i(0,0),0)
