extends Node
const forecast_info_panel = preload("res://forecast_info_panel.tscn")

@onready var weather: Node = $"../../Weather"
@onready var h_box_container: HBoxContainer = $VBoxContainer/ScrollContainer/HBoxContainer
@onready var forecast_label: Label = $VBoxContainer/ForecastLabelPanel/ForecastLabel
@onready var button: Button = $VBoxContainer/ForecastLabelPanel/Button

var current_forecast_detail : int
signal change_forecast_detail_level(level : int)

func set_forecast_panel(forecast: Array[WeatherData], level : int) -> void:
	current_forecast_detail = level
	for child in h_box_container.get_children():
		child.queue_free()
		
	for i in forecast.size():
		var panel = forecast_info_panel.instantiate()
		h_box_container.add_child(panel)
		panel.set_forecast_info_panel(forecast[i], level)
		match level:
			1:
				forecast_label.text = "Forecast: 12-Hour"
			2:
				forecast_label.text = "Forecast: 24-Hour"
			3:
				forecast_label.text = "Forecast: 1 Week"
			4:
				forecast_label.text = "Forecast: 2 Week"

func on_change_forecast_pressed() -> void:
	print("pressed")
	current_forecast_detail += 1
	if current_forecast_detail == 5:
		current_forecast_detail = 1
	change_forecast_detail_level.emit(current_forecast_detail)	
