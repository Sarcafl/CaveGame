extends State

class_name WallState

@export var wall_jump_velocity : float = -250
@export var double_jump_animation : String = "double_jump"
@export var landing_state : State
@export var air_state : State 

var wall_jumped = false
var state_timer: float = 0.2
var state_cooldown: float = 0

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		wall_jump()
	else:
		wall_jumped = false

func state_process(delta):
	state_cooldown -= delta
	if state_cooldown <= 0:
		if not character.is_on_wall():
			next_state = air_state
		elif character.is_on_floor():
			next_state = landing_state

func on_enter():
	state_cooldown = 0
	character.has_double_jumped = false

func wall_jump():
	character.velocity.y = wall_jump_velocity
	playback.travel(double_jump_animation)
	wall_jumped = true
	state_cooldown = state_timer
