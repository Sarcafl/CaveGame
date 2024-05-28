extends Control

@onready var play_button = $MarginContainer/VBoxContainer/Play
@onready var options_button = $MarginContainer/VBoxContainer/Options
@onready var credits_button = $MarginContainer/VBoxContainer/Credits
@onready var quit_button = $MarginContainer/VBoxContainer/Quit
@onready var audio_play = $audio_play
@onready var audio_click = $audio_click
@onready var audio_back = $audio_back

var waitTime : float = 1.2
var timer : float = 0

var sceneChanging : bool = false
var targetScene : String = ""

func _ready():
	pass

func _on_play_pressed():
	#get_tree().change_scene_to_file("res://Scenes/Levels/level_zero.tscn")
	targetScene = "res://Scenes/Levels/level_zero.tscn"
	sceneChanging = true
	
	audio_play.play()
	Fader._fade(1.1, true, true)
	
func _on_options_pressed():
	#get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")
	targetScene = "res://Scenes/optionsmenu.tscn"
	get_tree().change_scene_to_file(targetScene)
	#sceneChanging = true
	
	audio_click.play()
	
func _on_credits_pressed():
	#get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	targetScene = "res://Scenes/credits.tscn"
	get_tree().change_scene_to_file(targetScene)
	#sceneChanging = true
	
	audio_click.play()
	
func _on_quit_pressed():
	get_tree().quit()


func _process(delta):
	if not sceneChanging : return
	
	if timer < waitTime: 
		timer += delta
		return
	
	sceneChanging = false;
	timer = 0
	
	get_tree().change_scene_to_file(targetScene)
	if targetScene.contains("zero") : Fader._fade(0.5, true, false)


