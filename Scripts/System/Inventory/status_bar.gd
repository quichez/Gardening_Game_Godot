extends Node

@onready var player: Node = $"../../Player"

@onready var date: Label = $HBoxContainer/Date
@onready var time: Node = $"../../Time"
@onready var weather: Node = $"../../Weather"

@onready var cash_amount: Label = $HBoxContainer/CashLabel/CashAmount
@onready var temperature: Label = $HBoxContainer/Panel/Temperature
@onready var humidity: Label = $HBoxContainer/Panel/Humidity
@onready var season: Label = $HBoxContainer/Season
@onready var weather_pattern: Label = $HBoxContainer/Panel/WeatherPattern

func update_time_string(date_input : String) -> void:
	date.text = date_input

func update_cash_string(cash: Cash) -> void:
	cash_amount.text = cash.get_formatted_amount()
	
func update_weather_string(_temperature: int, _humidity: int, _season : String) -> void:
	temperature.text = str(_temperature) + "\u00B0F"
	humidity.text = str(_humidity) + "%"
	season.text = _season
	
func update_weather_pattern_string(string: String) -> void:
	weather_pattern.text = string
	
func _ready() -> void:
	player.cash_updated.connect(update_cash_string)
	time.date_updated.connect(update_time_string)
	weather.weather_updated.connect(update_weather_string)
	weather.weather_pattern_updated.connect(update_weather_pattern_string)
	
	update_weather_pattern_string("")
	
func _process(_delta: float) -> void:
	pass
