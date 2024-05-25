extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D

var jump_speed = -350
var gravity = 980
var speed = 150
var max_jumps = 2
var jump_count = 0

# Wall jumping variables
var is_touching_wall = false
var wall_direction = 0
var wall_jump_speed = 300  # Speed for horizontal wall jump

@onready var ray_left = $left
@onready var ray_right = $right


func _ready():
	pass
func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("right"):
		velocity.x = speed
		animated_sprite.play("walk")
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
		animated_sprite.play("walk")
		animated_sprite.flip_h = true
	else:
		velocity.x = 0
		animated_sprite.play("idle")
	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("jump") and (jump_count < max_jumps or (is_touching_wall)):
		velocity.y = jump_speed
		if is_touching_wall:
			velocity.x = wall_jump_speed * -wall_direction  # Jump away from the wall
		jump_count += 1

	# Wall detection using RayCast2D nodes
	if ray_right.is_colliding():
		is_touching_wall = true
		wall_direction = 1
	elif ray_left.is_colliding():
		is_touching_wall = true
		wall_direction = -1
	else:
		is_touching_wall = false
		wall_direction = 0
	move_and_slide()
