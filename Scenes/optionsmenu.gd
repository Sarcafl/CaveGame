extends Control




func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://Scenes/leaderboard.tscn")
