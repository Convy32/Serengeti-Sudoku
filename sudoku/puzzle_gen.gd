extends Control

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

@onready var grid_container = get_node("game.tscn/GridContainer")
#fix to find gc in game

func _ready() -> void:
	randomize()
	generate_and_load("easy")

func generate_and_load(selected_difficulty: String) -> void:
	difficulty = selected_difficulty
	solution = make_empty_grid()
	fill_grid(solution)

	puzzle = duplicate_grid(solution)
	remove_numbers_for_difficulty(puzzle, difficulty)
	load_puzzle()

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

func remove_numbers_for_difficulty(grid: Array, d: String) -> void:
	var removals := 40
	match d:
		"easy":
			removals = 30
		"medium":
			removals = 40
		"hard":
			removals = 50

	var removed := 0
	var attempts := removals * 3

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
