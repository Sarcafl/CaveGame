extends Area2D

func _on_body_entered(body):
	if body.name == "Guy": body.kill_player()
		#call_deferred("_restart")
		#Fader._flashRed()
		#DeathSounds.play()

func _restart():
	SafeSceneLoader._reloadScene()
