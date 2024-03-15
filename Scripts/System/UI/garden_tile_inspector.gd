extends Node

@onready var position: Label = $Panel/VBoxContainer/Basic/Position
@onready var moisture: Label = $Panel/VBoxContainer/Basic/Moisture
@onready var age: Label = $Panel/VBoxContainer/Basic/Age

@onready var nutrients: VBoxContainer = $Panel/VBoxContainer/Nutrients
@onready var nitrogen: Label = $Panel/VBoxContainer/Nutrients/Nitrogen
@onready var phosphorus: Label = $Panel/VBoxContainer/Nutrients/Phosphorus
@onready var potassium: Label = $Panel/VBoxContainer/Nutrients/Potassium
@onready var magnesium: Label = $Panel/VBoxContainer/Nutrients/Magnesium
@onready var calcium: Label = $Panel/VBoxContainer/Nutrients/Calcium
@onready var sulfur: Label = $Panel/VBoxContainer/Nutrients/Sulfur
@onready var copper: Label = $Panel/VBoxContainer/Nutrients/Copper
@onready var manganese: Label = $Panel/VBoxContainer/Nutrients/Manganese
@onready var iron: Label = $Panel/VBoxContainer/Nutrients/Iron
@onready var molybdenum: Label = $Panel/VBoxContainer/Nutrients/Molybdenum
@onready var zinc: Label = $Panel/VBoxContainer/Nutrients/Zinc
@onready var chlorine: Label = $Panel/VBoxContainer/Nutrients/Chlorine
@onready var boron: Label = $Panel/VBoxContainer/Nutrients/Boron

func set_inspector(tile_data: GardenTileData) -> void:
	position.text = "Tile (" + str(tile_data.x_pos) + "," + str(tile_data.y_pos) + ")"
	moisture.text = "Moisture: " + "%1.3f" % tile_data.moisture
	age.text = "Age: %s" % tile_data.age
	
	nitrogen.text = "Nitrogen: %1.3f" % tile_data.nitrogen
	phosphorus.text = "Phosphorus: %1.3f" % tile_data.phosphorus
	potassium.text = "Potassium: %1.3f" % tile_data.potassium
	magnesium.text = "Magnesium: %1.3f" % tile_data.magnesium
	calcium.text = "Calcium: %1.3f" % tile_data.calcium
	sulfur.text = "Sulfur: %1.3f" % tile_data.sulfur
	copper.text = "Copper: %1.3f" % tile_data.copper
	manganese.text = "Manganese: %1.3f" % tile_data.manganese
	iron.text = "Iron: %1.3f" % tile_data.iron
	molybdenum.text = "Molybdenum: %1.3f" % tile_data.molybdenum
	zinc.text = "Zinc: %1.3f" % tile_data.zinc
	chlorine.text = "Chlorine: %1.3f" % tile_data.chlorine
	boron.text = "Boron: %1.3f" % tile_data.boron
	
func show_nutrients(show : bool) -> void:
	if show:
		nutrients.show()
	else:
		nutrients.hide()
