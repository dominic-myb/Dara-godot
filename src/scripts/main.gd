extends Node2D

func _ready():
	Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://src/scenes/world.tscn")

func _on_exit_pressed():
	get_tree().quit()
