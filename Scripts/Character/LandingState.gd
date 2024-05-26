extends State

class_name LandingState

@export var landing_animation_name: String = "jump_end"
@export var ground_state: State
@export var wall_land_animation_name: String = "wall_land"

func state_process(_delta):
	if character.is_on_floor():
		# Do nothing specific for landing state process
		pass

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == landing_animation_name:
		character.state_machine.switch_states(ground_state)
	elif anim_name == wall_land_animation_name:
		character.state_machine.switch_states(ground_state)

func on_enter():
	if character.is_on_wall():
		playback.travel(wall_land_animation_name)
	else:
		playback.travel(landing_animation_name)

func on_exit():
	# Do nothing specific on exit
	pass
