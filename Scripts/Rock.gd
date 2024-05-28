extends RigidBody2D

@export var fall_delay = 1.0  # Time delay before the rock falls
@export var delete_delay = 5.0  # Time delay before the rock is deleted after hitting the ground
@onready var detection_area = $DetectionArea
@onready var jump_area = $JumpArea
@onready var ground_timer = $GroundTimer  # Ensure this Timer node is added to the scene
@onready var audio_fall = $audio_fall
@onready var audio_impact = $audio_impact
@onready var audio_jump = $audio_jump

var player_near = false
var fall_timer = 0.0
var initial_y = 0.0
var has_fallen = false

func _ready():
	gravity_scale = 0.0  # Initially disable gravity
	fall_timer = fall_delay  # Initialize the fall timer
	initial_y = global_position.y  # Store the initial y position

func _process(delta):
	if player_near and not has_fallen:
		fall_timer -= delta
		if fall_timer <= 0.0:
			gravity_scale = 1.0  # Enable gravity when player is near and timer ends
			has_fallen = true  # Mark as fallen
			audio_fall.play(0.2)
			

func _on_detection_area_body_entered(body):
	if body.name == "Guy":
		player_near = true
		fall_timer = fall_delay  # Reset the fall timer

func _on_detection_area_body_exited(body):
	if body.name == "Guy":
		player_near = false
		if has_fallen:
			var current_y = global_position.y
			if abs(current_y - initial_y) > 1:  # Check if the y position has changed significantly
				if ground_timer.is_inside_tree():  # Ensure the timer is inside the scene tree
					ground_timer.start(delete_delay)  # Start the timer to delete the rock

func _on_jump_area_body_entered(body):
	if body.name == "Guy":
		var player = body as CharacterBody2D
		player.velocity = Vector2(player.velocity.x, -400)  # Apply a high jump
		audio_jump.play()

func _on_ground_timer_timeout():
	queue_free()  # Delete the rock after the timer ends
