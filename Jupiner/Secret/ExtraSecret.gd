extends Node2D

@onready var animPlayer =  $AnimationPlayer
@onready var area = $Area2D

func _on_area_2d_2_body_entered(body):
	if body.name != "Guy": return
	area.set_deferred("monitoring", false)
	animPlayer.active = true
	animPlayer.play("ExtraSecretAnimation")
