extends RigidBody2D

@export var fall_delay = 1.0  # Time delay before the rock falls
@onready var detection_area = $DetectionArea
@onready var jump_area = $JumpArea

var player_near = false
var fall_timer = 0.0

func _ready():
	gravity_scale = 0.0  # Initially disable gravity
	fall_timer = fall_delay  # Initialize the fall timer

func _process(delta):
	if player_near:
		fall_timer -= delta
		if fall_timer <= 0.0:
			gravity_scale = 1.0  # Enable gravity when player is near and timer ends
		else:
			gravity_scale = 0.0  # Disable gravity when player is not near
	else:
		gravity_scale = 0.0

func _on_detection_area_body_entered(body):
	if body.name == "Guy": 
		player_near = true
		fall_timer = fall_delay  # Reset the fall timer
		print("I found the player")

func _on_detection_area_body_exited(body):
	if body.name == "Guy": 
		player_near = false
		print("I lost the player")

func dropROCK():
	if player_near:
		apply_central_impulse(Vector2(0, 180))  # Adjust magnitude as needed
		player_near = false  # Reset the flag
		print("Player is not near")

func _on_jump_area_body_entered(body):
	if body.name == "Guy":
		var player = body as CharacterBody2D
		player.velocity = Vector2(player.velocity.x, -400)  # Apply a high jump
