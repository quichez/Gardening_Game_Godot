extends TileMap

func initialize_grid(dimensions : Vector2i) -> Dictionary:
	var dic = {}
	for x in dimensions.x:
		for y in dimensions.y:
			set_cell(0,Vector2(x,y),0,Vector2i(0,0),0)
			dic[str(Vector2(x,y))] = GardenTileData.new()
			
	return dic
	
