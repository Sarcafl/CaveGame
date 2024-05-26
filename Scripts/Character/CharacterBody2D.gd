extends CharacterBody2D

# Exposed variables
@export var speed: float = 160
@export var jump_force: float = -180
@export var double_jump_force: float = -180
@export var gravity: float = 800.0

# Internal variables
var is_attached_to_wall: bool = false
var has_double_jumped: bool = false

# Animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	# Initialize animation
	animation_player.play("idle")

func _physics_process(delta):
	# Apply gravity
	if !is_attached_to_wall:
		velocity.y += gravity * delta

	# Move the character
	move_and_slide()

	# Update sprite flipping
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

	# Check for wall contact
	is_attached_to_wall = is_on_wall()

	# Update animations
	update_animations()

	# Handle input
	handle_input()

func handle_input():
	# Movement input
	var move_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = move_input * speed

	# Jump input
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif is_attached_to_wall:
			wall_jump()
		elif !has_double_jumped:
			double_jump()

func jump():
	velocity.y = jump_force
	animation_player.play("jump")

func double_jump():
	velocity.y = double_jump_force
	has_double_jumped = true
	animation_player.play("double_jump")

func wall_jump():
	velocity.y = jump_force
	if sprite.flip_h:
		velocity.x = speed
	else:
		velocity.x = -speed
	animation_player.play("wall_jump")

func update_animations():
	if is_on_floor():
		if velocity.x == 0:
			animation_player.play("idle")
		else:
			animation_player.play("walk")
	else:
		if velocity.y < 0:
			animation_player.play("jump")
		elif velocity.y > 0:
			animation_player.play("freefall")
		elif is_attached_to_wall:
			animation_player.play("wall_hold")
		else:
			animation_player.play("freefall")
