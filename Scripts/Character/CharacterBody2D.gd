extends CharacterBody2D

@export var speed: float = 200.0
@export var max_wall_jumps: int = 1  # Maximum wall jumps allowed

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var jump_sound = $JumpSound
@onready var footstep_dirt: AudioStreamPlayer2D = $FootstepDirt
@onready var footstep_timer: Timer = $FootstepTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO

var wall_jump_count: int = 0  # Counter for wall jumps

func _ready():
	add_to_group("Player")
	animation_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "jump", "down")
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		if is_on_floor() and footstep_timer.is_stopped():
			play_footstep_sound()
			footstep_timer.start()  # Start or restart the timer
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if not footstep_timer.is_stopped():
			footstep_timer.stop()

	move_and_slide()
	update_animation_parameters()
	update_facing_direction()

func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

func play_footstep_sound():
	if not footstep_dirt.playing:
		footstep_dirt.play()

func play_jump_sound():
	if not jump_sound.playing:
		jump_sound.play()

func reset_wall_jump_count():
	wall_jump_count = 0

func _on_footstep_timer_timeout():
	if is_on_floor() and abs(velocity.x) > 0.1:
		play_footstep_sound()
		footstep_timer.start()  # Restart the timer for continuous footstep sounds
