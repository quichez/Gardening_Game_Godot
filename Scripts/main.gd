extends Node2D
@onready var weather: Node = $Weather
@onready var time: Node = $Time

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
@onready var climate_information: PanelContainer = $UI/ClimateInformation

func _ready() -> void:
	initialize_inventory_interface()
	initialize_climate_information()
	time.initialize_time()
	weather.initialize_forecast()
	weather.set_current_weather()
	initialize_time_timer()
	
	#time.set_current_time(weather.full_forecast[0].date)

	player.add_to_cash(0)
	
func _increment() -> void:
	weather.increment_forecast()
	weather.set_current_weather()
	time.set_current_time(weather.full_forecast[0].date)
	pass
	
func initialize_inventory_interface () -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data)
	player.toggle_inventory.connect(toggle_inventory_interface)
	
func initialize_climate_information () -> void:
	climate_information.set_climate_info_panel_text(weather.selected_climate)
	player.toggle_climate_info.connect(toggle_climate_info_interface)
	
func initialize_time_timer() -> void:
	time.timer.connect("timeout",_increment)
	time.timer.start()
	
func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible

func toggle_climate_info_interface() -> void:
	climate_information.visible = not climate_information.visible
