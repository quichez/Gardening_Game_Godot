extends Node2D
@onready var weather: Node = $Weather
@onready var time: Node = $Time

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface

@export_group("Weather System Settings")
@onready var climate_information: PanelContainer = $UI/ClimateInformation
@onready var forecast_panel: PanelContainer = $UI/ForecastPanel
@export_range(1,4) var forecast_detail_level: int
var forecast_detail_counter : int

func _ready() -> void:
	#Initialize GUI elements, and set initial data if possible 
	initialize_inventory_interface()
	initialize_climate_information()
	initialize_forecast_panel()
	
	#Initialize time and weather in appropriate order
	time.initialize_time()
	weather.initialize_forecast()
	weather.set_current_weather()
	initialize_time_timer()
	
	#Set forecast panel (after time and weather is initialized)
	set_forecast_panel()
	
	#Initialize cash
	player.add_to_cash(0)
	
func _increment() -> void:
	#Increment weather, set current weather, and set current time.
	weather.increment_forecast()
	weather.set_current_weather()
	time.set_current_time(weather.full_forecast[0].date)
	
	#Set the forecast panel
	set_forecast_panel(true)
	
	
func initialize_inventory_interface () -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data)
	player.toggle_inventory.connect(toggle_inventory_interface)
	
func initialize_climate_information () -> void:
	climate_information.set_climate_info_panel_text(weather.selected_climate)
	player.toggle_climate_info.connect(toggle_climate_info_interface)
	
func initialize_forecast_panel() -> void:
	player.toggle_forecast_panel.connect(toggle_forecast_panel)
	forecast_panel.change_forecast_detail_level.connect(change_forecast_panel_detail_level)
	
func initialize_time_timer() -> void:
	time.timer.connect("timeout",_increment)
	time.timer.start()

func set_forecast_panel(update_counter: bool = false) -> void:
	forecast_panel.set_forecast_panel(weather.full_forecast,update_counter)
		
func change_forecast_panel_detail_level() -> void:	
	set_forecast_panel()
	
func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible

func toggle_climate_info_interface() -> void:
	climate_information.visible = not climate_information.visible

func toggle_forecast_panel() -> void:
	forecast_panel.visible = not forecast_panel.visible
