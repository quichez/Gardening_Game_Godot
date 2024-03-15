extends Control

var grabbed_slot_data : InventorySlotData

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot
@onready var tooltip: PanelContainer = $Tooltip
@onready var context_menu: PanelContainer = $ContextMenu

func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)
	if tooltip.visible:
		tooltip.global_position = get_global_mouse_position() + Vector2(20,5)
		
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	inventory_data.inventory_hovered.connect(update_tooltip)
	inventory_data.inventory_unhovered.connect(disable_tooltip)
	player_inventory.set_inventory_data(inventory_data)
	context_menu.set_signal_connections(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_slot_data, button]:	
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
			context_menu.hide()
		[_,MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data,index)
		[null, MOUSE_BUTTON_RIGHT]:
			tooltip.hide()
			if inventory_data.slot_datas[index]:
				print(inventory_data.slot_datas[index].item_data.name)
				context_menu.show()
				context_menu.set_context_menu_data(inventory_data, index)
				context_menu.position = get_global_mouse_position() - Vector2(20,5)
		[_,MOUSE_BUTTON_RIGHT]:			
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data,index)
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()
		
func update_tooltip(inventory_data: InventoryData, index: int) -> void:
	if inventory_data.slot_datas[index]:
		tooltip.set_tooltip(inventory_data.slot_datas[index])
		
func disable_tooltip() -> void:
	tooltip.visible = false
