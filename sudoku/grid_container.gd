extends GridContainer

const GRID_SIZE = 9

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(GRID_SIZE):
		var box = GridContainer.new()
		box.columns = sqrt(GRID_SIZE)
		for j in range(GRID_SIZE):
			var square = GridSpace.new()
			
			box.add_child(square)
		add_child(box)
	
