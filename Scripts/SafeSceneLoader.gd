extends Node

var loadingScene : bool = false

var timer : float = 0

func _loadScene(scenePath : String):
	if loadingScene : return
	else : loadingScene = true
	
	get_tree().change_scene_to_file(scenePath)


func _reloadScene():
	if loadingScene : return
	else : loadingScene = true
	
	get_tree().reload_current_scene()


func _process(delta):
	if not loadingScene : return
	timer += delta
	if timer >= 0.5 : loadingScene = false
