extends State

class_name GroundState

@export var wallJump_push = 800
@export var jump_velocity: float = -300
@export var air_state: State
@export var landing_state: State
@export var jump_animation: String = "jump"
@export var wall_hang_animation: String = "wall_hang"
@export var walk_animation: String = "walk"
@export var idle_animation: String = "idle"
@export var free_fall_animation: String = "free_fall"
@export var wall_land_animation: String = "wall_land"

var wall_slide_gravity = 50
var is_wall_sliding = false

func state_process(delta):
	if not character.is_on_floor() and not character.is_on_wall() and character.coyote_timer.is_stopped():
		character.state_machine.switch_states(air_state)
	elif is_wall_sliding or (character.is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))):
		is_wall_sliding = true
		wall_slide(delta)
	elif character.is_on_floor():
		is_wall_sliding = false
		character.reset_wall_jump_count()  # Reset wall jump count when on the ground
		if abs(character.velocity.x) > 0.1:
			playback.travel(walk_animation)
		else:
			playback.travel(idle_animation)

func state_input(_event: InputEvent):
	if is_wall_sliding and Input.is_action_pressed("jump"):
		perform_wall_jump()
	elif character.is_on_wall() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		is_wall_sliding = true
		playback.travel(wall_hang_animation)
	elif Input.is_action_pressed("jump"):
		jump()

func perform_wall_jump():
	if character.wall_jump_count < character.max_wall_jumps:  # Check if wall jump limit is reached
		character.velocity.y = jump_velocity
		if character.is_on_wall():
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

func jump():
	character.velocity.y = jump_velocity
	playback.travel(jump_animation)
	is_wall_sliding = false
	character.play_jump_sound()  # Play jump sound

func wall_slide(delta):
	if character.is_on_wall() and not character.is_on_floor():
		if not is_wall_sliding:
			playback.travel(wall_hang_animation)
		is_wall_sliding = true
		character.velocity.y = min(character.velocity.y + wall_slide_gravity * delta, wall_slide_gravity)
	else:
		is_wall_sliding = false
