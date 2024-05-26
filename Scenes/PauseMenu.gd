extends Control

@onready var resume = $MarginContainer/VBoxContainer/Resume
@onready var quit = $MarginContainer/VBoxContainer/Quit

func _ready():
	hide()  # Ensure the pause menu is hidden by default
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED  # Ensure the pause menu processes input when the game is paused

	# Set all child nodes to process input when the game is paused
	resume.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	quit.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_resume_pressed():
	get_tree().paused = false
	hide()  # Hide the pause menu



func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func show_pause_menu():
	get_tree().paused = true
	show()
