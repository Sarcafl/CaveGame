extends Control


@onready var play = $MarginContainer/VBoxContainer/Play
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var quit = $MarginContainer/VBoxContainer/Quit



func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainGameScene.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/optionsmenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
