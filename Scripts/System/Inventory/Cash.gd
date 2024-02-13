class_name Cash

var amount: int

func _init(value: int) -> void:
	amount = value
	
func get_formatted_amount() -> String:
	# Handle negative numbers by adding the "minus" sign in advance, as we discard it
	# when looping over the number.
	var formatted_number := "-" if sign(amount) == -1 else ""
	var index := 0
	var number_string := str(abs(amount))
	
	for digit in number_string:
		formatted_number += digit
		
		var counter := number_string.length() - index
		
		# Don't add a comma at the end of the number, but add a comma every 3 digits
		# (taking into account the number's length).
		if counter >= 2 and counter % 3 == 1:
			formatted_number += ","
			
		index += 1
	
	return "$" + formatted_number
