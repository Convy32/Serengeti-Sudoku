extends GridContainer

func _ready() -> void:
	for i in range(X.GRID_SIZE):
		for j in range(X.GRID_SIZE):
			var square = GridSpace.new()
			add_child(square)
