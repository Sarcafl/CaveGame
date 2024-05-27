extends Node

var speedrun_time: float = 0.0
var timer_running: bool = false  # Initially not running
@export var reset_scene_path = "res://Scenes/Levels/level_zero.tscn"  # Path to the scene to load when reset

func _ready():
	print("GlobalTimer ready, timer_running: %s" % timer_running)
	# Ensure the timer does not start immediately

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		reset_timer()
		get_tree().change_scene_to_file(reset_scene_path)
	
	if timer_running:
		speedrun_time += delta
	print("GlobalTimer _process: timer_running: %s, Time: %f" % [timer_running, speedrun_time])

func start_timer():
	timer_running = true
	print("GlobalTimer start_timer called: timer_running: %s" % timer_running)

func reset_timer():
	speedrun_time = 0.0
	timer_running = false
	print("GlobalTimer reset_timer called: timer_running: %s" % timer_running)

func stop_timer():
	timer_running = false
	print("GlobalTimer stop_timer called: timer_running: %s" % timer_running)
