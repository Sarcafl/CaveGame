extends Area2D

@onready var death_sound = $DeathSound
var reload_triggered = false  # Flag to prevent multiple reloads

func _ready():
	pass
func _on_body_entered(body):
	if body.name == "Guy" and not reload_triggered:
		reload_triggered = true      
		if death_sound:
			death_sound.play()
		else:
			call_deferred("_reload_scene")  # In case the sound is not available, reload immediately

func _reload_scene():
	print("Reloading scene")
	get_tree().reload_current_scene()

func _on_death_sound_finished():
	call_deferred("_reload_scene")
