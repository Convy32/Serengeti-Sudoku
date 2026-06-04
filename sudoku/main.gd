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
			s.color = Color(0.6, 0.0, 0.0, 0.75)
			result = false
	for s in spaces:
		if s.box_value in duplicate_numbers:
			s.color = Color(0.6, 0, 0, 0.75)
	
	return result


func _on_check_boxes_pressed() -> void:
	Globals.all_boxes_complete = false
	var complete = 0
	
	for box in $GridContainer.get_children():
		if box is GridContainer:
			if check_spaces(box.get_children()) == false:  #change to true
					complete += 1
	
	if complete == 9:
		Globals.all_boxes_complete = true
		print(Globals.all_boxes_complete)


func check_current_row():
	pass


func _on_check_current_box_pressed() -> void:
	check_spaces($GridContainer.get_child(2).get_children())


func check_all_rows() -> void:
	Globals.all_rows_complete = false
	var rowscomplete = 0
	
	for c in range(9):
		var row = []
		for r in range(9):
			row.append($GridContainer.get_child(r + (c * 9)))
			
		print(check_spaces(row))
		if check_spaces(row) == true:
			rowscomplete += 1

	if rowscomplete == 9:
		Globals.all_rows_complete = true
	
	print(Globals.all_rows_complete) #remove after testing

func check_all_columns() -> void:
	Globals.all_columns_complete = false
	var columnscomplete = 0
	
	for r in range(9):
		var column = []
		for c in range(9):
			column.append($GridContainer.get_child((c * 9) + r))
			
		if check_spaces(column) == true:
			columnscomplete += 1
		
	if columnscomplete == 9:
		Globals.all_columns_complete = true
		
	print()
	print(Globals.all_columns_complete) #remove after testing
