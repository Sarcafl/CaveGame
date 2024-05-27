extends Node

@export var reset_scene_path = "res://Scenes/Levels/level_zero.tscn"  # Path to the scene to load when reset

func _ready():
	print("GlobalTimer ready")
	# Ensure the timer does not start immediately

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		reset_timer()
		get_tree().change_scene_to_file(reset_scene_path)

func start_timer():
	SpeedrunTimer.start_timer()
	print("GlobalTimer start_timer called")

func reset_timer():
	SpeedrunTimer.reset_timer()
	print("GlobalTimer reset_timer called")

func stop_timer():
	SpeedrunTimer.stop_timer()
	print("GlobalTimer stop_timer called")
