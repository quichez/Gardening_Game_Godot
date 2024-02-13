extends Node

@onready var climate_name: RichTextLabel = $VBoxContainer/ClimateName
@onready var climate_info: RichTextLabel = $VBoxContainer/ClimateInfo

func set_climate_info_panel_text(climate: ClimateData) -> void:
	climate_name.text = climate.climate_name
	climate_info.text = climate.get_info_file()
