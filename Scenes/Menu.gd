extends Control

@onready var play_button = $MarginContainer/VBoxContainer/Play
@onready var options_button = $MarginContainer/VBoxContainer/Options
@onready var credits_button = $MarginContainer/VBoxContainer/Credits
@onready var quit_button = $MarginContainer/VBoxContainer/Quit
@onready var audio_play = $audio_play
@onready var audio_click = $audio_click
@onready var audio_back = $audio_back

@onready var fader = $Fader/ColorRect
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
	
func _on_options_pressed():
	#get_tree().change_scene_to_file("res://Scenes/OptionsMenu.tscn")
	targetScene = "res://Scenes/OptionsMenu.tscn"
	sceneChanging = true
	
	audio_click.play()
	
func _on_credits_pressed():
	#get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	targetScene = "res://Scenes/credits.tscn"
	sceneChanging = true
	
	audio_click.play()
	
func _on_quit_pressed():
	get_tree().quit()


func _process(delta):
	if not sceneChanging : return
	
	if timer < waitTime and targetScene.contains("zero") : 
		timer += delta
		fader.modulate = (lerp(Color(0,0,0,0), Color(0,0,0,1), timer/waitTime))
		return
	
	sceneChanging = false;
	timer = 0
	
	get_tree().change_scene_to_file(targetScene)


