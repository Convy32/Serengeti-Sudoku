extends Control

const NEW_GAME = preload("res://new_game.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	var game_selector = NEW_GAME.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(game_selector)
