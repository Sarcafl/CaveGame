extends Node

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		SpeedrunTimer.reset_game()
