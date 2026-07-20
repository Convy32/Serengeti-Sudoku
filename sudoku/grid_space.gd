class_name GridSpace
extends ColorRect

var label
var active = false
var box_value
var fixed = false

func _ready() -> void:
	add_to_group("grid_spaces")
	custom_minimum_size = Vector2(50, 50)
	color = Color.WHITE
	if fixed:
		color = Color.LIGHT_GRAY
	label = Label.new()
	add_child(label)
	box_value = ""
	label.size = Vector2(50, 50)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			for space in get_tree().get_nodes_in_group("grid_spaces"):
				space.active = false
				space.color = Color.WHITE
				if space.fixed:
					space.color = Color.LIGHT_GRAY
			active = true
			color = Color.DARK_GRAY

func _input(event: InputEvent) -> void:
	if not fixed:
		if event is InputEventKey and event.pressed and active:
			if OS.get_keycode_string(event.keycode) in "123456789":
				var inputnum = OS.get_keycode_string(event.keycode)
				label.text = inputnum
				box_value = inputnum
			elif OS.get_keycode_string(event.keycode) == "Backspace":
				label.text = ""
				box_value = ""
