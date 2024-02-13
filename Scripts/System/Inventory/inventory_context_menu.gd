extends PanelContainer

@onready var label: Label = $Area2D/ItemLabel/Label
@onready var extract: Button = $Area2D/Panel2/VBoxContainer/Extract
@onready var compost: Button = $Area2D/Panel2/VBoxContainer/Compost
@onready var dispose: Button = $Area2D/Panel2/VBoxContainer/Dispose
@onready var sell: Button = $Area2D/Panel2/VBoxContainer/Sell

var index : int
signal item_extracted(index: int)
signal item_composted
signal item_disposed
signal item_sold

func set_signal_connections(inventory_data: InventoryData) -> void:
	item_extracted.connect(inventory_data.extract_item)
	item_extracted.connect(inventory_data.compost_item)
	item_extracted.connect(inventory_data.dispose_item)
	item_extracted.connect(inventory_data.sell_item)
	
func set_context_menu_data(inventory_data: InventoryData, slot_index: int) -> void:
	index = slot_index 
	
	if inventory_data.slot_datas[index]:
		label.text = inventory_data.slot_datas[index].item_data.name
	else:
		print("magic error sometimes")
	extract.disabled = true
	compost.disabled = true
	dispose.disabled = true
	sell.disabled = true
	
	if inventory_data.slot_datas[index].item_data.extractable:
		extract.disabled = false
	if inventory_data.slot_datas[index].item_data.compostable:
		compost.disabled = false
	if inventory_data.slot_datas[index].item_data.disposable:
		dispose.disabled = false
	if inventory_data.slot_datas[index].item_data.sellable:
		sell.disabled = false
		
func _on_area_2d_mouse_exited() -> void:	
	hide()

func on_click_extract_button() -> void:
	item_extracted.emit(index)
	hide()
	
func on_click_compost_button() -> void:
	item_composted.emit(index)
	hide()

func on_click_dispose_button() -> void:
	item_disposed.emit(index)
	hide()
	
func on_click_sell_button() -> void:
	item_sold.emit(index)
	hide()
