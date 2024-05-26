extends Control

@onready var pause_menu = $PauseMenu

func _ready():
	pause_menu.hide() 

func _input(event):
	if event.is_action_pressed("esc"): 
		if not pause_menu.is_visible():
			pause_menu.show_pause_menu()
		else:
			pause_menu._on_resume_pressed()
