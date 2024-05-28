extends Node

@export var music : Array[AudioStreamPlayer]
var currentSong : int = -1
var paused = false

var volume = Vector2(-30, -6)
var fadingSong = -1
var fadeTime = 0.5
var timer = 0.0

func loadingLevel(levelName : String):
	match(levelName):
		"Start": playMusic(0)
		"Cave": playMusic(1)
		_: stopMusic()

func playMusic(song : int):
	if song == currentSong : return
	if song >= music.size() : return
	
	stopMusic()
	
	currentSong = song
	music[currentSong].volume_db = volume.y
	music[currentSong].play()

func pauseMusic(pause : bool):
	if currentSong == -1 : return
	else : music[currentSong].stream_paused = pause

func stopMusic():
	if currentSong != -1 : fadingSong = currentSong
	currentSong = -1

func _process(delta):
	if fadingSong == -1 : return
	
	timer +=  delta
	music[fadingSong].volume_db = lerp(volume.y, volume.x, timer / fadeTime)
	
	if timer >= fadeTime : 
		music[fadingSong].stop()
		fadingSong = -1
