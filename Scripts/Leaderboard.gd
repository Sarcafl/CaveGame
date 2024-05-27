extends Control

@onready var leaderboard_container = $VBoxContainer
@onready var back_button = $VBoxContainer/Back

const MAX_ENTRIES = 10
var leaderboard_entries = []

func _ready():
	prepopulate_labels()
	load_leaderboard()

func prepopulate_labels():
	# Ensure the labels exist and are named correctly
	for i in range(MAX_ENTRIES):
		var label_name = "Label" + str(i + 1)
		if not leaderboard_container.has_node(label_name):
			var label = Label.new()
			label.name = label_name
			leaderboard_container.add_child(label)
		update_label(i, "Level: -", "Time: -")

func load_leaderboard():
	var leaderboard = SpeedrunTimer.load_leaderboard()
	leaderboard_entries.clear()
	
	for entry in leaderboard:
		# Debugging: Print each entry to verify its structure
		print(entry)
		if "Level" in entry and "Time" in entry:
			leaderboard_entries.append({
				"Level": entry["Level"],
				"Time": entry["Time"]
			})
		else:
			print("Invalid entry: ", entry)
	
	# Sort entries by time (ascending)
	leaderboard_entries.sort_custom(compare_times)
	
	# Update the labels with the sorted entries
	for i in range(MAX_ENTRIES):
		if i < leaderboard_entries.size():
			var entry = leaderboard_entries[i]
			update_label(i, entry["Level"], str(entry["Time"]))
		else:
			update_label(i, "Level: -", "Time: -")
			
	leaderboard_container.add_child(HSeparator.new())  # Add a separator between runs

func update_label(index, level, time):
	var label = leaderboard_container.get_node("Label" + str(index + 1))
	label.text = "%s, %s" % [level, time]

func compare_times(a, b):
	return int(a["Time"] * 1000) - int(b["Time"] * 1000)  # Compare times in milliseconds

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/optionsmenu.tscn")
