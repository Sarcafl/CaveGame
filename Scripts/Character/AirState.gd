extends State

class_name AirState

@export var landing_state: State
@export var double_jump_velocity: float = -250
@export var double_jump_animation: String = "double_jump"
@export var landing_animation: String = "landing"
@export var wall_hang_animation: String = "wall_hang"
@export var free_fall_animation: String = "free_fall"
@export var wall_land_animation: String = "wall_land"
@export var jump_velocity: float = -300
@export var wallJump_push = 600
@export var jump_animation: String = "jump"

var has_double_jumped = false
var is_wall_sliding = false
var fall_time: float = 0.5  # Time after which free fall animation should be triggered
var fall_timer: float = 0.0

func state_process(delta):
	if character.is_on_floor():
		character.state_machine.switch_states(landing_state)
	elif character.is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		is_wall_sliding = true
		playback.travel(wall_land_animation)  # Play wall land animation when grabbing the wall
		character.state_machine.switch_states(character.state_machine.ground_state)  # Switch to ground state to handle wall slide
	else:
		fall_timer += delta
		if fall_timer >= fall_time:
			playback.travel(free_fall_animation)

func state_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		if is_wall_sliding:
			perform_wall_jump()
		elif not has_double_jumped:
			double_jump()

func on_enter():
	fall_timer = 0.0  # Reset the fall timer

func on_exit():
	if next_state == landing_state:
		playback.travel(landing_animation)
		has_double_jumped = false
	is_wall_sliding = false
	fall_timer = 0.0  # Reset the fall timer

func double_jump():
	character.velocity.y = double_jump_velocity
	playback.travel(double_jump_animation)
	has_double_jumped = true
	character.play_jump_sound()  # Play jump sound

func perform_wall_jump():
	if character.wall_jump_count < character.max_wall_jumps:  # Check if wall jump limit is reached
		character.velocity.y = jump_velocity
		if Input.is_action_pressed("right"):
			character.velocity.x = -wallJump_push
		elif Input.is_action_pressed("left"):
			character.velocity.x = wallJump_push
		else:
			character.velocity.x = -sign(character.velocity.x) * wallJump_push
		playback.travel(jump_animation)
		is_wall_sliding = false
		character.wall_jump_count += 1  # Increment wall jump count
		character.play_jump_sound()  # Play jump sound
