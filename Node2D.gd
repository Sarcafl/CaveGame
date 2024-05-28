extends Node

func _process(_delta):
	var sceneName : String = str(get_tree().current_scene)
	if sceneName.contains("Menu") || sceneName.contains("Credits"): return
	
	if Input.is_action_just_pressed("reset"):
		Music.stopMusic()
		SpeedrunTimer.reset_game()
