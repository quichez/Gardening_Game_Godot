extends PanelContainer

signal slot_clicked(index: int, button: int)
signal slot_hovered(index: int)
signal slot_unhovered()

@onready var icon : TextureRect	= $Icon
@onready var quantity_panel : Panel	= $QuantityPanel
@onready var quantity_text : Label = $QuantityPanel/QuantityText

func set_slot_data(slot_data: InventorySlotData) -> void:
	var item_data = slot_data.item_data
	icon.texture = item_data.texture
	icon.visible = true
	quantity_panel.visible = item_data.stackable
	if quantity_panel.visible:
		quantity_text.text = "%s" % slot_data.quantity

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
		
		
func _on_mouse_entered() -> void:
	slot_hovered.emit(get_index())
	
func _on_mouse_exited() -> void:
	slot_unhovered.emit()
