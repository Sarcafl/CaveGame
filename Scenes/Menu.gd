extends Control

@onready var play_button = $MarginContainer/VBoxContainer/Play
@onready var options_button = $MarginContainer/VBoxContainer/Options
@onready var credits_button = $MarginContainer/VBoxContainer/Credits
@onready var quit_button = $MarginContainer/VBoxContainer/Quit

func _ready():
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_zero.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_quit_pressed():
	get_tree().quit()
