extends Area2D

func _on_body_entered(body):
	if body.name == "Guy":
		call_deferred("_restart")
		DeathSounds.play()

func _restart():
	SafeSceneLoader._reloadScene()
