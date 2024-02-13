extends Node

@export var inventory_data : InventoryData
var cash : Cash
var test : int

signal toggle_inventory
signal toggle_climate_info
signal cash_updated(cash: Cash)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	if Input.is_action_just_pressed("climate_info"):
		toggle_climate_info.emit()

func add_to_cash(amount: int) -> void:
	cash.amount += amount
	cash_updated.emit(cash)
	
func subtract_from_cash(amount: int) -> void:
	cash.amount -= amount
	cash.amount = max(0,cash.amount)
	cash_updated.emit(cash)
	
func _ready() -> void:
	cash = Cash.new(0)
	cash_updated.emit(cash)
	
func _process(_delta: float) -> void:
	test += 1
	if(test > 100):
		test = 0
		add_to_cash(1)
