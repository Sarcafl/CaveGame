extends Control

@onready var play_button = $MarginContainer/VBoxContainer/Play
@onready var options_button = $MarginContainer/VBoxContainer/Options
@onready var credits_button = $MarginContainer/VBoxContainer/Credits
@onready var quit_button = $MarginContainer/VBoxContainer/Quit
@onready var audio_play = $audio_play
@onready var audio_click = $audio_click
@onready var audio_back = $audio_back


func _ready():
	pass

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_zero.tscn")
	#audio_play.play()
	
func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")
	#audio_click.play()
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	#audio_click.play()
	
func _on_quit_pressed():
	get_tree().quit()
