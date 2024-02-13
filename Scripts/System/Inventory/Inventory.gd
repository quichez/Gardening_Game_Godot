extends PanelContainer

const Slot = preload("res://Scripts/System/Inventory/inventory_slot.tscn")

@onready var slot_container: GridContainer = $MarginContainer/GridContainer

func _ready() -> void:
	pass
	
func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_slot_grid)
	populate_slot_grid(inventory_data)
	
func populate_slot_grid(inventory_data: InventoryData) -> void:
	for child in slot_container.get_children():
		child.queue_free()
		
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		slot_container.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		slot.slot_hovered.connect(inventory_data.on_slot_hovered)
		slot.slot_unhovered.connect(inventory_data.on_slot_unhovered)
		
		if slot_data:
			slot.set_slot_data(slot_data)
