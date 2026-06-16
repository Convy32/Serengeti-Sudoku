extends Control


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	Globals.difficulty = "medium"
	get_tree().change_scene_to_file("res://game.tscn")
	
