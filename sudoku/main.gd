extends Control

var healthmode = false #will be used later for difficult levels, where you take
						#damage if you check incorrectly
var health = 3 #used for above

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

func get_active_space() -> int:
	var space_active
	
	for s in range($GridContainer.get_child_count()): #get amount of spaces (s)
		var space = $GridContainer.get_child(s)
		if space.active:
			return s #return the useable space id (0-80)
	return -1 #return -1 if there is no active space so it doesnt mess with it
	

func test_as() -> void:
	var acti
	acti = get_active_space()
	print(acti)





func check_all_rows() -> void:
	Globals.all_rows_complete = false
	var rowscomplete = 0
	
	for c in range(9):
		var row = []
		for r in range(9):
			row.append($GridContainer.get_child(r + (c * 9)))
			
		if check_spaces(row) == true:
			rowscomplete += 1

	if rowscomplete == 9:
		Globals.all_rows_complete = true

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

func check_all_boxes() -> void:
	Globals.all_boxes_complete = false
	var boxescomplete = 0
	
	for br in range(3):
		for bc in range(3):
			var box = []
			for r in range(3):
				for c in range(3):
					box.append($GridContainer.get_child(c + (9 * r) + (3 * bc) + (27 * br)))
				
			if check_spaces(box) == true:
				boxescomplete += 1
		
	if boxescomplete == 9:
		Globals.all_boxes_complete = true

func check_puzzle():
	check_all_boxes()
	check_all_rows()
	check_all_columns()
	
	if (Globals.all_boxes_complete
	and Globals.all_rows_complete 
	and Globals.all_columns_complete):
		game_win()
	elif healthmode == true:
		health -= 1

func game_win():
	pass

func game_lose():
	pass
