extends Control


func check_spaces(spaces: Array):
	var result = true
	var numbers_found = []
	var duplicate_numbers = []
	
	for s in spaces:
		if s.box_value in numbers_found:
			result = false
			duplicate_numbers.append(s.box_value)
		if s.box_value:
			numbers_found.append(s.box_value)
		if s.box_value == "":
			s.color = Color(0.54509807, 0, 0, 0.75)
			result = false
	for s in spaces:
		if s.box_value in duplicate_numbers:
			s.color = Color(0.54509807, 0, 0, 0.75)
	
	return result


func _on_check_boxes_pressed() -> void:
	var complete = 0
	for i in range(2, 11):
		if check_spaces($GridContainer.get_child(i).get_children()) == true:
			complete += 1
	if complete == 9:
		print("all complete")


func _on_check_current_box_pressed() -> void:
	check_spaces($GridContainer.get_child(2).get_children())
