extends State
@export var wall_jump_velocity : float = -250
@export var double_jump_animation : String = "double_jump"
@export var landing_state : State
@export var air_state : State 

var wall_jumped = false

func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		wall_jump()
	else:
		wall_jumped = false

func state_process(delta):
	if(!character.is_on_floor() or !character.is_on_wall()):
		next_state = landing_state
	if(!character.is_on_floor() and character.is_on_wall()):
		next_state = air_state
func wall_jump():
	character.velocity.y = wall_jump_velocity
	playback.travel(double_jump_animation)
	wall_jumped = true
