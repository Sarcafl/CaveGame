extends CanvasLayer

@onready var label = $Control/Sprite2D/Label

func _ready():
	$Control.position = Vector2(0,0)

func _physics_process(_delta):
	
	label.text = SpeedrunTimer._getFormattedTime()
	#var time = SpeedrunTimer.speedrun_time
	#update_ui(time)

func update_ui(_time):
	# Format time with two decimal places
	#var formatted_time = str(time)
	#var decimal_index = formatted_time.find(".")
	#if decimal_index > 0: formatted_time = formatted_time.left(decimal_index + 3) 
	pass
	
