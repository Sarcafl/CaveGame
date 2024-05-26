extends State

class_name GroundState

@export var wall_jump_animation : String = ""
@export var wallJump_push = 600
@export var jump_velocity : float = -300
@export var air_state : State
@export var jump_animation : String = "jump"

var wall_slide_gravity = 1000
var is_wall_sliding = false

func state_process(delta):
	if !character.is_on_floor() and !character.is_on_wall():
		next_state = air_state
	wall_slide(delta)

func state_input(event : InputEvent):
	if Input.is_action_pressed("jump"):
		if character.is_on_wall():
			perform_wall_jump()
		else:
			jump()

func perform_wall_jump():
	if Input.is_action_pressed("right"):
		character.velocity.y = jump_velocity
		character.velocity.x = -wallJump_push
		playback.travel(wall_jump_animation)
	elif Input.is_action_pressed("left"):
		character.velocity.y = jump_velocity
		character.velocity.x = wallJump_push
		playback.travel(wall_jump_animation)
	else:
		# Default to jumping away from the wall if no direction is pressed
		character.velocity.y = jump_velocity
		character.velocity.x = -sign(character.velocity.x) * wallJump_push
		playback.travel(wall_jump_animation)

func jump():
	character.velocity.y = jump_velocity
	playback.travel(jump_animation)

func wall_slide(delta):
	if character.is_on_wall() and !character.is_on_floor():
		is_wall_sliding = true
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		character.velocity.y += wall_slide_gravity * delta
		character.velocity.y = min(character.velocity.y, wall_slide_gravity)
