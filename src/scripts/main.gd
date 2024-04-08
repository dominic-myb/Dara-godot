extends Node2D

func _ready():
	Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	get_node("AnimationPlayer").play("Play")
	await get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://src/scenes/world_sea.tscn")

func _on_load_pressed():
	get_node("AnimationPlayer").play("Load")
	await get_node("AnimationPlayer").animation_finished
	#add here the scene for load game

func _on_quit_pressed():
	get_node("AnimationPlayer").play("Quit")
	await get_node("AnimationPlayer").animation_finished
	get_tree().quit()
