extends State

class_name AirState

@export var landing_state : State
@export var double_jump_velocity : float = -100
@export var double_jump_animation : String = "double_jump"
@export var freefall : String = "freefall"
@export var wall_state : State 
var has_double_jumped = false
var state_timer: float = 0.2
var state_cooldown: float = 0

func state_process(delta):
	state_cooldown -= delta
	if state_cooldown <= 0:
		if character.is_on_floor():
			next_state = landing_state
		elif character.is_on_wall():
			next_state = wall_state
func state_input(event : InputEvent):
	if event.is_action_pressed("jump") and not has_double_jumped:
		double_jump()

func on_exit():
	if next_state == landing_state:
		playback.travel(freefall)
		has_double_jumped = false
	state_cooldown = state_timer

func on_enter():
	state_cooldown = 0

func double_jump():
	character.velocity.y = double_jump_velocity
	playback.travel(double_jump_animation)
	has_double_jumped = true
