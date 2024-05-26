# LandingState.gd
extends State

class_name LandingState

@export var landing_animation_name: String = "jump_end"
@export var ground_state: State
@export var wall_land_animation_name: String = "wall_land"

func state_process(delta):
	if character.is_on_floor():
		print("In LandingState on the floor")

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == landing_animation_name:
		print("Landing animation finished, switching to GroundState")
		character.state_machine.switch_states(ground_state)
	elif anim_name == wall_land_animation_name:
		print("Wall land animation finished, switching to GroundState")
		character.state_machine.switch_states(ground_state)

func on_enter():
	print("Entering LandingState")
	if character.is_on_wall():
		playback.travel(wall_land_animation_name)
	else:
		playback.travel(landing_animation_name)

func on_exit():
	print("Exiting LandingState")
