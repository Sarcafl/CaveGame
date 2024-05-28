extends Node

var loadingScene : bool = false
var timer : float = 0

var endingIndex : int = 0

func _loadScene(scenePath : String):
	if loadingScene : return
	else : loadingScene = true
	
	get_tree().change_scene_to_file(scenePath)

func _loadWithFade(scenePath : String, fadeTime : float, fadeBlack : bool, levelName : String):
	if loadingScene : return
	else : loadingScene = true
	
	var fadeColor : bool = fadeBlack
	if scenePath.contains("end"):
		if not levelName.contains("Descend"): 
			endingIndex = 0
			fadeColor = false
		else : 
			endingIndex = 1
	
	Fader._fade(fadeTime, fadeColor, true)
	await get_tree().create_timer(0.5).timeout
	
	get_tree().change_scene_to_file(scenePath)
	Fader._fade(fadeTime, fadeColor, false)

func _reloadScene():
	if loadingScene : return
	else : loadingScene = true
	
	var sceneName = get_tree().get_current_scene().get_name()
	print(sceneName)
	if sceneName.contains("Main") : SpeedrunTimer.reset_timer()
	
	get_tree().reload_current_scene()


func _process(delta):
	if not loadingScene : return
	timer += delta
	if timer >= 0.5 : loadingScene = false
