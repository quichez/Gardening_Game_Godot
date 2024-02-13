extends Resource
class_name InventoryData

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal inventory_updated(inventory_data: InventoryData)
signal inventory_hovered(inventory_data: InventoryData, index: int)
signal inventory_unhovered()

@export var slot_datas: Array[InventorySlotData]

func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)

func on_slot_hovered(index: int) -> void:
	inventory_hovered.emit(self,index)
	
func on_slot_unhovered() -> void:
	inventory_unhovered.emit()
	
func grab_slot_data(index: int) -> InventorySlotData:
	var slot_data = slot_datas[index]
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: InventorySlotData, index: int) -> InventorySlotData:
	var slot_data = slot_datas[index]
	var return_slot_data: InventorySlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	elif slot_data and slot_data.can_partially_merge_with(grabbed_slot_data):
		return_slot_data = slot_data.partially_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: InventorySlotData, index: int) -> InventorySlotData:
	var slot_data = slot_datas[index]	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	
	inventory_updated.emit(self)
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func add_to_inventory(slot_data: InventorySlotData) -> bool:
	for slot in slot_datas:
		if slot and slot.can_partially_merge_with(slot_data):
			var new_slot = slot.partially_merge_with(slot_data)
			inventory_updated.emit(self)
			add_to_inventory(new_slot)
			return true
	
	for slot in slot_datas:
		if slot and slot.can_fully_merge_with(slot_data):
			slot.fully_merge_with(slot_data)
			print(slot.quantity)
			inventory_updated.emit(self)
			return true

	for slot in slot_datas:
		if not slot:
			slot = slot_data
			inventory_updated.emit(self)
			return true
	return false

func extract_item(index: int) -> void:	
	var extracted_slot = slot_datas[index].item_data.extracted_item_slot_data
	
	slot_datas[index].quantity -= 1	
	add_to_inventory(extracted_slot)
	if slot_datas[index].quantity == 0:
		slot_datas[index] = null
	inventory_updated.emit(self)
	
func compost_item(_index: int) -> void:
	pass
	
func dispose_item(_index: int) -> void:
	pass
	
func sell_item(_index: int) -> void:
	pass
