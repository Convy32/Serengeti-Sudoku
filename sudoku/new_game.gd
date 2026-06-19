extends Control

func new_game(extra_arg_0: String) -> void:
	Globals.difficulty = extra_arg_0
	Globals.health = 3
	queue_free()
	get_tree().change_scene_to_file("res://game.tscn")

func close_menu():
	queue_free()
