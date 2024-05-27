extends Area2D

@export var scenePath: String = ""
@export var level_name: String = ""

func _ready():
	pass

func _on_body_entered(body):
	if body.name == "Guy":  # Ensure this matches your player node's name
		SpeedrunTimer.complete_level(level_name)
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file(scenePath)
