extends Node

signal toggle_inventory()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
