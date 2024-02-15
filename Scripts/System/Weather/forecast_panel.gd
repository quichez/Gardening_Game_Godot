extends Node
const forecast_info_panel = preload("res://forecast_info_panel.tscn")

@onready var weather: Node = $"../../Weather"
@onready var h_box_container: HBoxContainer = $ScrollContainer/HBoxContainer

func set_forecast_panel(forecast: Array[WeatherData], level : int) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
		
	for i in forecast.size():
		var panel = forecast_info_panel.instantiate()
		h_box_container.add_child(panel)
		panel.set_forecast_info_panel(forecast[i], level)
