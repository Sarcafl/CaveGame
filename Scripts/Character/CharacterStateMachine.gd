# CharacterStateMachine.gd
extends Node

class_name CharacterStateMachine

@export var character: CharacterBody2D
@export var animation_tree: AnimationTree
@export var current_state: State
@export var ground_state: State

var states: Array[State] = []

func _ready():
	states = []
	for child in get_children():
		if child is State:
			states.append(child)
			child.character = character
			child.playback = animation_tree["parameters/playback"]
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")
	
	# Set initial state if current_state is not set in inspector
	if current_state == null:
		current_state = ground_state
	
	if current_state != null:
		current_state.on_enter()
	else:
		push_error("Current state is not set")

func _physics_process(delta):
	if current_state != null and current_state.next_state != null:
		switch_states(current_state.next_state)
	current_state.state_process(delta)

func check_if_can_move():
	return current_state != null and current_state.can_move

func switch_states(new_state: State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	print("Switching to state: ", current_state)
	if current_state != null:
		current_state.on_enter()
	else:
		push_error("New state is null in switch_states")

func _input(event: InputEvent):
	if current_state != null:
		current_state.state_input(event)
