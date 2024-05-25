extends State

class_name LandingState

@export var landing_animation_name: String = "jump_end"
@export var ground_state: State

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == landing_animation_name:
		next_state = ground_state

func state_process(delta):
	if character.is_on_floor() and not character.is_on_wall():
		next_state = ground_state
