extends Node2D
@onready var weather: Node = $Weather
@onready var time: Node = $Time

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
@onready var climate_information: PanelContainer = $UI/ClimateInformation

func _ready() -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data)
	player.toggle_inventory.connect(toggle_inventory_interface)
	climate_information.set_climate_info_panel_text(weather.selected_climate)
	player.toggle_climate_info.connect(toggle_climate_info_interface)
	
	weather.initialize_forecast()
	weather.set_weather()
	player.add_to_cash(0)
	
func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible

func toggle_climate_info_interface() -> void:
	climate_information.visible = not climate_information.visible
