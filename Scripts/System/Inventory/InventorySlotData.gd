extends Resource
class_name InventorySlotData

const MAX_STACK_SIZE: int = 999
@export var item_data: ItemData 
@export_range(1,MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity

func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		push_error("%s is not stackable")

func can_merge_with(other_slot_data: InventorySlotData) -> bool:
	return item_data == other_slot_data.item_data \
		and item_data.stackable \
		and quantity < MAX_STACK_SIZE
		
func can_fully_merge_with(other_slot_data: InventorySlotData) -> bool:
	return item_data == other_slot_data.item_data \
		and item_data.stackable \
		and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

func can_partially_merge_with(other_slot_data: InventorySlotData) -> bool:
	return item_data == other_slot_data.item_data \
		and item_data.stackable \
		and quantity + other_slot_data.quantity > MAX_STACK_SIZE \
		and quantity != MAX_STACK_SIZE
		
func fully_merge_with(other_slot_data: InventorySlotData) -> void:
	quantity = quantity + other_slot_data.quantity

func partially_merge_with(other_slot_data: InventorySlotData) -> InventorySlotData:
	var overflow = quantity + other_slot_data.quantity - MAX_STACK_SIZE
	quantity = min(quantity + other_slot_data.quantity,MAX_STACK_SIZE)

	var new_item : InventorySlotData = InventorySlotData.new()
	new_item.item_data = other_slot_data.item_data
	new_item.quantity = overflow
	return new_item
	
func create_single_slot_data() -> InventorySlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data
