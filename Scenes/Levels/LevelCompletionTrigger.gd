extends Area2D

@export var scenePath: String = ""
@export var level_name: String = ""

@export var fade : bool = true
@export var fadeBlack : bool = true
var fadeTime = 0.4

func _ready():
	pass

func _on_body_entered(body):
	if body.name == "Guy":  # Ensure this matches your player node's name
		SpeedrunTimer.complete_level(level_name)
		call_deferred("_change_scene")

func _change_scene():
	if not fade : SafeSceneLoader.loadScene(scenePath)
	else : SafeSceneLoader._loadWithFade(scenePath, fadeTime, fadeBlack, level_name)
