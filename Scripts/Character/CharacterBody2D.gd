extends CharacterBody2D

@export var speed: float = 200.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine

@onready var footstep_crystal: AudioStreamPlayer2D = $FootstepCrystal
@onready var footstep_dirt: AudioStreamPlayer2D = $FootstepDirt
@onready var footstep_grass: AudioStreamPlayer2D = $FootstepGrass
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var footstep_timer: Timer = $FootstepTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var floor_type: String = "dirt"  # Default floor type

func _ready():
	add_to_group("Player")
	animation_tree.active = true

	print("Checking for TileMap node...")
	var tile_map = get_node("/root/Main/level_layout") as TileMap
	if tile_map:
		print("TileMap found and is of type TileMap")
	else:
		print("TileMap not found or incorrect type")

	# Check if the audio streams are correctly set
	if footstep_crystal.stream:
		print("FootstepCrystal audio stream found")
	else:
		print("FootstepCrystal audio stream not found")
	
	if footstep_dirt.stream:
		print("FootstepDirt audio stream found")
	else:
		print("FootstepDirt audio stream not found")
	
	if footstep_grass.stream:
		print("FootstepGrass audio stream found")
	else:
		print("FootstepGrass audio stream not found")
	
	if jump_sound.stream:
		print("JumpSound audio stream found")
	else:
		print("JumpSound audio stream not found")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_vector("left", "right", "jump", "down")
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		if is_on_floor():
			set_floor_type_based_on_tile()
			if footstep_timer.is_stopped():
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
	print("Playing footstep sound for floor type: ", floor_type)
	match floor_type:
		"Crystal":
			if not footstep_crystal.playing:
				footstep_crystal.play()
				print("Playing Crystal footstep sound")
		"dirt":
			if not footstep_dirt.playing:
				footstep_dirt.play()
				print("Playing Dirt footstep sound")
		"grass":
			if not footstep_grass.playing:
				footstep_grass.play()
				print("Playing Grass footstep sound")

func play_jump_sound():
	print("Playing jump sound")
	if not jump_sound.playing:
		jump_sound.play()

func set_floor_type(new_floor_type: String):
	floor_type = new_floor_type

func set_floor_type_based_on_tile():
	print("set_floor_type_based_on_tile called")
	var tile_map = get_node("/root/Main/level_layout") as TileMap  # Adjust the path to your TileMap node
	if not tile_map:
		print("TileMap node not found or incorrect type")
		return

	print("TileMap node found")
	var player_position = global_position
	print("Player position (global): ", player_position)
	var local_player_position = tile_map.to_local(player_position)
	print("Player position (local): ", local_player_position)

	var cell = tile_map.local_to_map(local_player_position)
	print("Cell: ", cell)

	# Ensure the cell is within the tile map bounds
	var used_rect = tile_map.get_used_rect()
	print("TileMap used rect: ", used_rect)
	if not used_rect.has_point(cell):
		print("Cell is out of bounds: ", cell)
		return

	# Get the source ID of the tile at the cell position
	var source_id = tile_map.get_cell_source_id(0, cell)
	print("Source ID: ", source_id)
	
	if source_id == -1:
		print("No tile found under the player")
		return  # No tile found under the player

	var terrain_value = tile_map.tile_set.get_custom_data(source_id, "TerrainType")
	print("Terrain value: ", terrain_value)

	if terrain_value != null:
		floor_type = terrain_value
		print("Terrain type set to: ", floor_type)
	else:
		print("No custom data for TerrainType found")

func _on_footstep_timer_timeout():
	if is_on_floor() and abs(velocity.x) > 0.1:
		play_footstep_sound()
		footstep_timer.start()  # Restart the timer for continuous footstep sounds
