class_name GridSpace
extends ColorRect

var label 
var active = false
var box_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("grid_spaces")
	custom_minimum_size = Vector2(50, 50)
	color = Color.WHITE
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
			active = true
			color = Color.GRAY
			#on_event is InputEventKey:
				#label.text = "1"
			#label.text = "3"

func _input(event: InputEvent) -> void:
	
		if event is InputEventKey and event.pressed and active:
			if OS.get_keycode_string(event.keycode) in "123456789":
				var inputnum = OS.get_keycode_string(event.keycode)
				label.text = inputnum
				box_value = inputnum
			elif OS.get_keycode_string(event.keycode) == "Backspace":
				label.text = ""
				box_value = ""
			
