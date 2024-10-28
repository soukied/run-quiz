extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !MainMenuMusic.playing:
		MainMenuMusic.play()


func back_to_menu() -> void:
	get_tree().change_scene_to_file("res://scene/main_menu_scene.tscn")