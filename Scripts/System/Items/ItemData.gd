extends Resource
class_name ItemData

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var compostable: bool = false
@export var disposable: bool = false
@export var sellable: bool = false
@export var extractable: bool = false
@export var texture: AtlasTexture 

@export var purchase_price: int
@export var sell_price: int

@export var extracted_item_slot_data: InventorySlotData

func get_extraction_description() -> String:
	if extractable and extracted_item_slot_data:
		return "Can extract for " + str(extracted_item_slot_data.quantity) + " " + str(extracted_item_slot_data.item_data.name) + ".\n"
	else:
		return ""

func get_sale_price_as_string() -> String:
	if sellable:
		return "Sells for $%s.\n" % sell_price
	else:
		return "Cannot sell.\n"
		
func extract(_target) -> void:
	pass

func compost(_target) -> void:
	pass
	
func dispose(_target) -> void:
	pass
	
func sell(_target) -> void:
	pass
