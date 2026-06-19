extends Control

const new_game = preload("res://new_game.tscn")

@export var global_grid_container = GridContainer

func _ready() -> void:
	randomize()
	start_generation(Globals.difficulty)

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
			result = false
			if Globals.difficulty == "easy" or Globals.difficulty == "medium":
				s.color = Color(0.6, 0.0, 0.0, 0.75)
	for s in spaces:
		if s.box_value in duplicate_numbers:
			if Globals.difficulty == "easy" or Globals.difficulty == "medium":
				s.color = Color(0.6, 0, 0, 0.75)
	
	return result

func get_active_space() -> int:
	for s in range($GridContainer.get_child_count()): #get amount of spaces(s)
		var space = $GridContainer.get_child(s)
		if space.active:
			return s #return the useable space id (0-80)
	return 0 #return 0 if there is no active space (functions use this)

func get_current_row():
	@warning_ignore("integer_division")
	var active_row = floor(get_active_space() / 9)
	return active_row

func get_current_column():
	var active_column = (get_active_space() - (get_current_row() * 9))
	return active_column

func check_current_row():
	if Globals.difficulty == "easy":
		var spaces = []
		for s in range(9):
			spaces.append($GridContainer.get_child((get_current_row() * 9) + s))
		check_spaces(spaces)

func check_current_column():
	if Globals.difficulty == "easy":
		var spaces = []
		for s in range(9):
			spaces.append($GridContainer.get_child(get_current_column() + (s * 9)))
		check_spaces(spaces)

func check_current_box():
	if Globals.difficulty == "easy":
		var box_row = floor(get_current_row() / 3)
		var box_column = floor(get_current_column() / 3)
		
		var spaces = []
		for br in range(3):
			for bc in range(3): #line below should maybe be put onto 2 lines
				spaces.append($GridContainer.get_child((box_row * 27) + bc + (br * 9) + (box_column * 3)))
		check_spaces(spaces)

func check_all_rows() -> void:
	if Globals.difficulty == "medium" or Globals.difficulty == "easy":
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
	if Globals.difficulty == "medium" or Globals.difficulty == "easy":
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
	if Globals.difficulty == "medium" or Globals.difficulty == "easy":
		Globals.all_boxes_complete = false
		var boxescomplete = 0
		
		for br in range(3):
			for bc in range(3):
				var box = []
				for r in range(3):
					for c in range(3): #line below should be put onto 2 lines
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
	elif Globals.difficulty == "hardcore":
		Globals.health -= 1
		if Globals.health <= 0:
			game_lose()

func game_win():
	pass

func game_lose():
	var game_selector = new_game.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(game_selector)

func _on_new_game_pressed() -> void:
	var game_selector = new_game.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(game_selector)

func _on_check_all_id_pressed(id: int) -> void:
	if id == 0: #boxes
		check_all_boxes()
	elif id == 1: #rows
		check_all_rows()
	elif id == 2: #cols
		check_all_columns()


func _on_check_current_id_pressed(id: int) -> void:
	if id == 0: #box
		check_current_box()
	if id == 1: #row
		check_current_row()
	if id == 2: #col
		check_current_column()


func input_button_pressed(extra_arg_0: int) -> void:
	var grid_space = $GridContainer.get_child(get_active_space())
	if not grid_space.fixed:
		grid_space.box_value = str(extra_arg_0)
		grid_space.label.text = str(extra_arg_0)

func eraser_button_pressed() -> void:
	var grid_space = $GridContainer.get_child(get_active_space())
	if not grid_space.fixed:
		grid_space.box_value = ""
		grid_space.label.text = ""





# PUZZLE GENERATOR SECTION

# This script was built from an algorithm by 101computing.net
# It was then converted to a useable GD script by AI
# I do not claim any credit for this part, as none of the code was made by me
# This is essentially acting as an API, just adapted for Godot.
# https://www.101computing.net/sudoku-generator-algorithm/
# Thank you internet

const SIZE := 9

var solution: Array = []
var puzzle: Array = []
var difficulty := "easy"

@onready var grid_container = $GridContainer
@onready var loading_screen = $LoadingScreen

func start_generation(selected_difficulty: String) -> void:
	difficulty = selected_difficulty
	
	# Show loading screen
	loading_screen.visible = true
	loading_screen.update_progress(10, "Generating puzzle...")
	
	# Start generation in chunks
	await generate_and_load_chunked(selected_difficulty)
	
	# Hide loading screen and show puzzle
	loading_screen.visible = false
	load_puzzle()

func generate_and_load_chunked(selected_difficulty: String) -> void:
	# Chunk 1: Create empty grid
	solution = make_empty_grid()
	await get_tree().process_frame
	loading_screen.update_progress(20, "Building solution...")
	
	# Chunk 2: Fill grid
	fill_grid(solution)
	await get_tree().process_frame
	loading_screen.update_progress(40, "Solution complete...")
	
	# Chunk 3: Copy to puzzle
	puzzle = duplicate_grid(solution)
	await get_tree().process_frame
	loading_screen.update_progress(50, "Removing numbers...")
	
	# Chunk 4: Remove numbers (do this in smaller chunks)
	await remove_numbers_chunked(puzzle, selected_difficulty)
	
	loading_screen.update_progress(100, "Done!")
	await get_tree().process_frame

func remove_numbers_chunked(grid: Array, d: String) -> void:
	var removals := 40
	match d:
		"easy":
			removals = 40
		"medium":
			removals = 50
		"hard":
			removals = 60
		"hardcore":
			removals = 70

	var removed := 0
	var attempts := removals * 3
	var chunk_size := 1  # Process X removals per frame
	var chunk_count := 0

	while removed < removals and attempts > 0:
		attempts -= 1
		var r := randi() % SIZE
		var c := randi() % SIZE
		if grid[r][c] == 0:
			continue

		var backup = grid[r][c]
		grid[r][c] = 0

		var test_grid = duplicate_grid(grid)
		var solutions := count_solutions(test_grid, 2)

		if solutions == 1:
			removed += 1
		else:
			grid[r][c] = backup
		
		chunk_count += 1
		if chunk_count >= chunk_size:
			chunk_count = 0
			await get_tree().process_frame
			var progress = (float(removed) / float(removals)) * 50
			var total_progress = 50 + progress
			loading_screen.update_progress(total_progress, "Removing numbers...")

func make_empty_grid() -> Array:
	var grid := []
	for r in range(SIZE):
		grid.append([])
		for c in range(SIZE):
			grid[r].append(0)
	return grid

func duplicate_grid(src: Array) -> Array:
	var copy := []
	for r in range(SIZE):
		copy.append(src[r].duplicate())
	return copy

func fill_grid(grid: Array) -> bool:
	for r in range(SIZE):
		for c in range(SIZE):
			if grid[r][c] == 0:
				var nums = [1,2,3,4,5,6,7,8,9]
				nums.shuffle()
				for n in nums:
					if is_valid(grid, r, c, n):
						grid[r][c] = n
						if fill_grid(grid):
							return true
						grid[r][c] = 0
				return false
	return true

func is_valid(grid: Array, row: int, col: int, n: int) -> bool:
	for c in range(SIZE):
		if grid[row][c] == n:
			return false
	for r in range(SIZE):
		if grid[r][col] == n:
			return false

	@warning_ignore("integer_division")
	var start_row := (row / 3) * 3
	@warning_ignore("integer_division")
	var start_col := (col / 3) * 3
	for r in range(start_row, start_row + 3):
		for c in range(start_col, start_col + 3):
			if grid[r][c] == n:
				return false
	return true

func count_solutions(grid: Array, limit: int) -> int:
	return count_solutions_recursive(grid, limit, 0)

func count_solutions_recursive(grid: Array, limit: int, found: int) -> int:
	for r in range(SIZE):
		for c in range(SIZE):
			if grid[r][c] == 0:
				for n in range(1, 10):
					if is_valid(grid, r, c, n):
						grid[r][c] = n
						found = count_solutions_recursive(grid, limit, found)
						if found >= limit:
							grid[r][c] = 0
							return found
						grid[r][c] = 0
				return found
	return found + 1

func load_puzzle() -> void:
	for i in range(81):
		@warning_ignore("integer_division")
		var r := i / 9
		var c := i % 9
		var space: GridSpace = grid_container.get_child(i)

		space.box_value = "" if puzzle[r][c] == 0 else str(puzzle[r][c])
		space.label.text = space.box_value
		space.color = Color.LIGHT_GRAY if puzzle[r][c] != 0 else Color.WHITE
		if puzzle[r][c] != 0:
			space.fixed = true
		
