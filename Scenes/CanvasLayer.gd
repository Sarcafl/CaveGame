extends CanvasLayer

func _physics_process(delta):
	var time = SpeedrunTimer.speedrun_time
	update_ui(time)

func update_ui(time):
	# Format time with two decimal places
	var formatted_time = str(time)
	var decimal_index = formatted_time.find(".")

	if decimal_index > 0:
		formatted_time = formatted_time.left(decimal_index + 3)  # Take only two decimal places

	$Label.text = formatted_time
