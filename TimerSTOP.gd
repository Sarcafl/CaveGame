extends Area2D

@export var player_name = "Guy"

func _ready():
	print("StopTimerArea ready, connected body_entered signal")

func _on_body_entered(body):
	if body.name == player_name:
		print("Guy entered area")
		GlobalTimer.stop_timer()
