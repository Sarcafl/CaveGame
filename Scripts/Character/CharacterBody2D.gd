extends CharacterBody2D

@export var speed : float = 200.0
@onready var animation_player = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

# Add has_double_jumped variable
var has_double_jumped = false

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "jump", "down")
	
	# Control whether to move or not to move
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animation_player.play("idle")
	move_and_slide()
	update_animation_parameters()
	update_facing_direction()
	
func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true