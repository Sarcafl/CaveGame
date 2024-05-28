extends Control


@onready var audio_play = $audio_play
@onready var audio_birds = $audio_birds

@onready var watchLabel = $VBoxContainer/Stopwatch/CenterContainer/WatchLabel
@onready var mainLabel = $VBoxContainer/MainLabel
@onready var colorRect = $ColorRect

var waitTime : float = 1.2
var timer : float = 0

var sceneChanging : bool = false
var targetScene : String = ""

func _ready():
	#var runTime = SpeedrunTimer.time
	watchLabel.text = SpeedrunTimer._getFormattedTime()
	SpeedrunTimer.reset_timer()
	#Fader._fade(0.5, false, false)
	
	match(SafeSceneLoader.endingIndex):
		0: 
			mainLabel.text = "You found\na way up!"
			colorRect.color = Color.WHITE
			Ambience.stop()
			audio_birds.play()
		1:
			mainLabel.text = "You descend\ninto the cave"
			colorRect.color = Color.BLACK


func _process(delta):
	if not sceneChanging : return
	
	if timer < waitTime and targetScene.contains("zero") : 
		timer += delta
		return
	
	
	sceneChanging = false;
	timer = 0
	
	get_tree().change_scene_to_file(targetScene)
	Fader._fade(0.5, false, false)


func _on_play_pressed():
	targetScene = "res://Scenes/Levels/level_zero.tscn"
	sceneChanging = true
	
	audio_play.play()


func _on_quit_pressed():
	get_tree().quit()
