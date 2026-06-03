extends GridContainer

const GRID_SIZE = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = GRID_SIZE
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var square = GridSpace.new()
			add_child(square)
	
