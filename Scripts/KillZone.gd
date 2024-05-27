extends Area2D
@onready var death_sounds = $DeathSounds

func _on_body_entered(body):
	if body.name == "Guy":
		death_sound()
func death_sound():
	if death_sounds:
		death_sounds.play()
func _reload_scene():
	get_tree().reload_current_scene()


func _on_death_sounds_finished():
	_reload_scene()
