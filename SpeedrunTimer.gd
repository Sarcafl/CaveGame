extends Node

var speedrun_time: float = 0.0
var timer_running: bool = false
@export var reset_scene_path = "res://Scenes/Levels/level_zero.tscn"
@export var final_level: String = "res://Scenes/Levels/level_three.tscn"
var leaderboard_data = []

func _ready():
	print("SpeedrunTimer ready, timer_running: %s" % timer_running)
	load_leaderboard_data()

func _process(delta):
	if timer_running:
		speedrun_time += delta

func start_timer():
	timer_running = true
	
func reset_timer():
	speedrun_time = 0.0
	timer_running = false
	
func stop_timer():
	timer_running = false

func reset_game():
	reset_timer()
	get_tree().change_scene_to_file(reset_scene_path)

func complete_level(level_name: String):
	if level_name == final_level:
		stop_timer()
		print("Final level completed, stopping timer. Total time: %f" % speedrun_time)
	else:
		print("Level completed: %s" % level_name)
	save_current_run(level_name)

func save_current_run(level_name: String):
	var run_data = {"Level": level_name, "Time": speedrun_time}
	leaderboard_data.append(run_data)
	save_leaderboard_data()

func save_leaderboard_data():
	var file = FileAccess.open("user://leaderboard.save", FileAccess.WRITE)
	if file:
		file.store_var(leaderboard_data)
		file.close()

func load_leaderboard_data():
	var file = FileAccess.open("user://leaderboard.save", FileAccess.READ)
	if file:
		leaderboard_data = file.get_var()
		file.close()

func load_leaderboard():
	return leaderboard_data

func get_total_time():
	var total_time = 0.0
	for entry in leaderboard_data:
		total_time += entry["Time"]
	return total_time
