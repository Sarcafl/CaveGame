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
	if(!character.is_on_floor() and !character.is_on_wall()):
		next_state = air_state
		wall_slide(delta)
func state_input(event : InputEvent):
	if(Input.is_action_pressed("jump")):
		jump()
		if character.is_on_wall() and Input.is_action_pressed("right"):
			character.velocity.y = jump_velocity
			character.velocity.x = -wallJump_push
			playback.travel(wall_jump_animation)
		if character.is_on_wall() and Input.is_action_pressed("left"):
			character.velocity.y = jump_velocity
			character.velocity.x = wallJump_push
			playback.travel(wall_jump_animation)
func jump():
	character.velocity.y = jump_velocity
	
func wall_slide(delta):
	if character.is_on_wall() and !character.is_on_floor():
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			is_wall_sliding = true
		else:
			is_wall_sliding =false
	else:
		is_wall_sliding = false
	if is_wall_sliding:
		character.velocity.y +=(wall_slide_gravity * delta)
		character.velocity.y = min(character.velocity.y, wall_slide_gravity)


