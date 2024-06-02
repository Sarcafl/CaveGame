extends CharacterBody2D

@export var speed: float = 200.0
@export var max_wall_jumps: int = 3 # Maximum wall jumps allowed
var wall_jump_count: int = 0  # Counter for wall jumps

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
@onready var coyote_timer : Timer = $CoyoteTimer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO
var was_on_floor : bool = false
var lastTerrainType : String = "Grass"

var dead = false


func _ready():
	add_to_group("Player")
	animation_tree.active = true


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if dead : return
	
	manage_input()
	move_and_slide()
	check_collision()
	
	if was_on_floor && !is_on_floor() && not Input.is_action_pressed("jump"): coyote_timer.start()
	
	update_animation_parameters()
	update_facing_direction()

func manage_input():
	direction = Input.get_vector("left", "right", "jump", "down")
	
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		if is_on_floor() and footstep_timer.is_stopped(): footstep_timer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if not footstep_timer.is_stopped(): footstep_timer.stop()
	
	was_on_floor = is_on_floor()

func reset_wall_jump_count():
	wall_jump_count = 0


func check_collision():
	var collision = get_last_slide_collision()
	if !collision: return
	
	var colliderRID = collision.get_collider_rid()
	if !colliderRID: return
	
	var collisionLayer : int = PhysicsServer2D.body_get_collision_layer(colliderRID)
	
	match(collisionLayer): # in bits
		1: # physics layer 1 (player) in bits
			pass
		2: # physics layer 2 (ground) in bits
			var tileMap = collision.get_collider()
			if tileMap.get_class() == "TileMap" : get_tile_terrain(tileMap)
		4: # physics layers 3 (ground hazards) in bits
			kill_player()
		8: # physics layer 4 (hazards) in bits
			pass

func get_tile_terrain(tileMap : TileMap):
	var footstepGlobalPosition = footstep_position.global_position
	var footstepPositionRelativeToTileMap = tileMap.to_local(footstepGlobalPosition)
	var characterCellCoordinates = tileMap.local_to_map(footstepPositionRelativeToTileMap)
	var tileId = tileMap.get_cell_tile_data(0, characterCellCoordinates)
	
	if tileId:
		var data = tileId.get_custom_data("TerrainType")
		lastTerrainType = data
		#print(lastTerrainType)

func kill_player():
	if dead : return
	else : dead = true
	
	Fader._flashRed()
	DeathSounds.play()
	call_deferred("_restart")

func _restart():
	SafeSceneLoader._reloadScene()

# animation
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)

func update_facing_direction():
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true

# sound
func play_footstep_sound():
	match lastTerrainType:
		"Grass": audio_footstep_dirt.play()
		"Dirt": audio_footstep_dirt.play()
		"Rock": audio_footstep_rock.play()
		"Crystal": audio_footstep_crystal.play()

func _on_footstep_timer_timeout():
	if is_on_floor() and abs(velocity.x) > 0.1:
		footstep_timer.start()  # Restart the timer for continuous footstep sounds

func play_jump_sound():
	audio_jump_sound.play()

func on_jump_end():
	match lastTerrainType:
		"Grass": audio_footstep_dirt.play()
		"Dirt": audio_footstep_dirt.play()
		"Rock": audio_footstep_rock.play()
		"Crystal": audio_footstep_crystal.play()
