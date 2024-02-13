extends PanelContainer
@onready var item_image: TextureRect = $Panel/ItemImage
@onready var item_name: Label = $Panel/ItemName
@onready var quantity: Label = $Panel/Quantity
@onready var item_info: Label = $Panel/ItemInfo

func set_tooltip(slot_data: InventorySlotData) -> void:
	var item_data = slot_data.item_data
	if item_data:
		item_image.texture = item_data.texture
		item_name.text = item_data.name
		quantity.visible = item_data.stackable
		quantity.text = "x " + str(slot_data.quantity)
		visible = true	
		
		var item_info_text = item_data.description + "\n" + \
			item_data.get_extraction_description() + \
			item_data.get_sale_price_as_string()
			
		item_info.text = item_info_text
