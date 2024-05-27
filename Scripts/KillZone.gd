extends Area2D

func _on_body_entered(body):
	if body.name == "Guy":
		call_deferred("_reload_scene")

func _reload_scene():
	get_tree().reload_current_scene()
