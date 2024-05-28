extends CharacterBody2D

@export var speed: float = 200.0
@export var max_wall_jumps: int = 3 # Maximum wall jumps allowed

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var audio_jump_sound = $audio_jump_sound
@onready var audio_jump_end_dirt = $audio_jump_end_dirt
@onready var audio_jump_end_rock = $audio_jump_end_rock
@onready var audio_jump_end_crystal = $audio_jump_end_crystal
@onready var audio_footstep_dirt: AudioStreamPlayer2D = $audio_footstep_dirt
@onready var audio_footstep_rock: AudioStreamPlayer2D = $audio_footstep_rock
@onready var audio_footstep_crystal: AudioStreamPlayer2D = $audio_footstep_crystal
@onready var footstep_timer: Timer = $FootstepTimer
@onready var footstep_position: Node = $FootPosition

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO

var wall_jump_count: int = 0  # Counter for wall jumps
@onready var coyote_timer : Timer = $CoyoteTimer
var was_on_floor : bool = false

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
			footstep_timer.start()  # Start or restart the timer
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if not footstep_timer.is_stopped():
			footstep_timer.stop()
	
	was_on_floor = is_on_floor() # coyote time pt 1
	move_and_slide()
	if was_on_floor && !is_on_floor() && not Input.is_action_pressed("jump"): coyote_timer.start()
	
	update_animation_parameters()
	update_facing_direction()
	
	

func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true
	
func play_footstep_sound():
	var tile_map = get_tree().current_scene.get_node("level_layout")
	var footstepGlobalPosition = footstep_position.global_position
	var footstepPositionRelativeToTileMap = tile_map.to_local(footstepGlobalPosition)
	var characterCellCoordinates = tile_map.local_to_map(footstepPositionRelativeToTileMap)
	var tileId = tile_map.get_cell_tile_data(0, characterCellCoordinates)
	
	if tileId:
		var data = tileId.get_custom_data("TerrainType")
		match data:
			"Grass": audio_footstep_dirt.play()
			"Dirt": audio_footstep_dirt.play()
			"Rock": audio_footstep_rock.play()
			"Crystal": audio_footstep_crystal.play()

func play_jump_sound():
	audio_jump_sound.play()

func on_jump_end():
	var tile_map = get_tree().current_scene.get_node("level_layout")
	var footstepGlobalPosition = footstep_position.global_position
	var footstepPositionRelativeToTileMap = tile_map.to_local(footstepGlobalPosition)
	var characterCellCoordinates = tile_map.local_to_map(footstepPositionRelativeToTileMap)
	var tileId = tile_map.get_cell_tile_data(0, characterCellCoordinates)
	
	if tileId:
		var data = tileId.get_custom_data("TerrainType")
		match data:
			"Grass": audio_jump_end_dirt.play()
			"Dirt": audio_jump_end_dirt.play()
			"Rock": audio_jump_end_rock.play()
			"Crystal": audio_jump_end_crystal.play()

func reset_wall_jump_count():
	wall_jump_count = 0

func _on_footstep_timer_timeout():
	if is_on_floor() and abs(velocity.x) > 0.1:
		footstep_timer.start()  # Restart the timer for continuous footstep sounds
