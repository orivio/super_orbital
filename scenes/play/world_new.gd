class_name World_New
extends Node2D


signal level_changed(new_level_idx: int)


enum WorldState {
	UNINITIALIZED,
	INITIALIZED,
	NORMAL,
	STARTING_LEVEL_TRANSITION,
	FADING_TO_BLACK,
	DESTROYING_OLD_LEVEL,
	SPAWNING_NEW_LEVEL,
	WAITING_FOR_PLAYER_PHYSICS_FRAME,
	FADING_FROM_BLACK,
}


@export_category("World Settings")
@export var transition_fade_duration: float
@export var transition_fade_color: Color


var current_level: Level = null
var previous_level: Level = null
var current_level_idx: int
var last_transition_direction: Types.EastWestNoneDirection
var world_state: WorldState

var fade_to_black_tween_during_transition: Tween
var fade_from_black_tween_during_transition: Tween
var level_instance_during_transition: Level
var level_change_direction_after_transition: Types.EastWestNoneDirection
var new_level_idx_after_transition: int
var should_save_after_transition: bool


@onready var current_level_container: Node2D = $CurrentLevelContainer
@onready var player: Player = $Player
@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var fade_effect: FadeEffect = $FadeEffect


func _ready() -> void:
	# TODO: WARNING: SPAGHETTI CODE
	player.player_death.connect(reload_level)
	
	world_state = WorldState.UNINITIALIZED
	get_tree().physics_frame.connect(_on_physics_frame_finished)

func initialize(save_file: SaveFile) -> void:
	# Get the level data
	var level_idx: int = save_file.level_idx
	# TODO: WARNING: Potential spaghetti code right here
	if level_idx == 0:
		last_transition_direction = Types.EastWestNoneDirection.NONE
	else:
		last_transition_direction = Types.EastWestNoneDirection.EAST
	world_state = WorldState.INITIALIZED
	# Change to the first room
	change_level(level_idx, last_transition_direction, false)
	player.load_abilities()

func change_level(new_level_idx: int, direction: Types.EastWestNoneDirection, should_save: bool) -> void:
	# A few validation checks
	if world_state != WorldState.INITIALIZED && world_state != WorldState.NORMAL:
		return
	if new_level_idx < 0 or new_level_idx >= GameManager.get_level_count():
		return
	world_state = WorldState.STARTING_LEVEL_TRANSITION
	level_change_direction_after_transition = direction
	should_save_after_transition = should_save
	new_level_idx_after_transition = new_level_idx
	
	
	# Fetch the level metadata
	var level_metadata: LevelMeta = GameManager.get_level_meta(new_level_idx)
	var level_scene_path: String = level_metadata.scene_path
	print("Retrieved level metadata")
	
	# Instantiate the scene
	var level_scene: PackedScene = load(level_scene_path)
	level_instance_during_transition = level_scene.instantiate()
	print("Instantiated level scene")
	
	# Freeze everything in place for now
	# TODO: After refactoring the player script, maybe use a slightly better way of disabling the player
	player.process_mode = Node.PROCESS_MODE_DISABLED
	player_camera.process_mode = Node.PROCESS_MODE_DISABLED
	print("Disabled player and camera process mode")
	
	# Start the fade effect
	world_state = WorldState.FADING_TO_BLACK
	fade_to_black_tween_during_transition = fade_effect.fade(transition_fade_color, transition_fade_duration)
	fade_to_black_tween_during_transition.finished.connect(_on_fade_to_black_tween_finished)

func _physics_process(_delta: float) -> void:
	match world_state:
		_:
			return

func reload_level() -> void:
	change_level(current_level_idx, last_transition_direction, false)

func _on_level_transition_entered(direction: Types.EastWestNoneDirection) -> void:
	#print("Old: ", current_level_idx, ", direction: ", direction, ", new: ", direction + current_level_idx)
	change_level(current_level_idx + direction, direction, true)

func _on_fade_to_black_tween_finished() -> void:
	if world_state == WorldState.FADING_TO_BLACK:
		fade_to_black_tween_during_transition = null
		destroy_old_level()
	else:
		assert(false, "Invalid state!")

func destroy_old_level() -> void:
	if is_instance_valid(current_level):
		current_level.queue_free()
		if is_instance_valid(current_level):
			world_state = WorldState.DESTROYING_OLD_LEVEL
			current_level.tree_exited.connect(_on_old_level_destroy_finished)
		else:
			spawn_new_level()
	else:
		spawn_new_level()

func _on_old_level_destroy_finished() -> void:
	if world_state == WorldState.DESTROYING_OLD_LEVEL:
		spawn_new_level()
	else:
		assert(false, "Invalid state!")

func spawn_new_level() -> void:
	world_state = WorldState.SPAWNING_NEW_LEVEL
	current_level_container.add_child(level_instance_during_transition)
	if not level_instance_during_transition.is_node_ready():
		level_instance_during_transition.ready.connect(_on_new_level_spawned)
	else:
		setup_new_level()

func _on_new_level_spawned() -> void:
	if world_state == WorldState.SPAWNING_NEW_LEVEL:
		setup_new_level()
	else:
		assert(false, "Invalid state!")

func setup_new_level() -> void:
	# Set up level
	level_instance_during_transition.level_transition_entered.connect(_on_level_transition_entered)
	
	# Adjust the player
	# TODO: After refactoring the player script, I will probably have to do this differently
	# Not sure if I should really reenable the camera's process mode here. I'm just doing it so that can actually snap to the player.
	player_camera.process_mode = Node.PROCESS_MODE_INHERIT
	if level_change_direction_after_transition == Types.EastWestNoneDirection.NONE:
		player.teleport_to_ground(Vector2.ZERO)
		player_camera.snap_camera_to_player()
		print("Teleported the player to (0, 0)")
		world_state = WorldState.WAITING_FOR_PLAYER_PHYSICS_FRAME
		get_tree().physics_frame.connect(_on_physics_frame_finished)
	else:
		# Find the destination level transition (the inverse of the direction you came from)
		var destination_transition: LevelTransition = level_instance_during_transition.get_level_transition(-level_change_direction_after_transition)
		var spawn_pos: Vector2 = destination_transition.get_player_spawn_position()
		
		player.teleport_to_ground(spawn_pos)
		player_camera.snap_camera_to_player()
		print("Teleported the player to the level transition at ", spawn_pos)
		world_state = WorldState.WAITING_FOR_PLAYER_PHYSICS_FRAME
		# physics frame signal is connected already

func _on_physics_frame_finished() -> void:
	if world_state == WorldState.WAITING_FOR_PLAYER_PHYSICS_FRAME:
		fade_from_black()

func fade_from_black() -> void:
	world_state = WorldState.FADING_FROM_BLACK
	fade_from_black_tween_during_transition = fade_effect.fade(Color(transition_fade_color, 0), transition_fade_duration)
	fade_from_black_tween_during_transition.finished.connect(_on_fade_from_black_tween_finished)

func _on_fade_from_black_tween_finished() -> void:
	if world_state == WorldState.FADING_FROM_BLACK:
		fade_from_black_tween_during_transition = null
		finish_level_change()
	else:
		assert(false, "Invalid state!")

func finish_level_change() -> void:
	# Unfreeze everything
	player.process_mode = Node.PROCESS_MODE_INHERIT
	print("Unfroze the player")
	
	# Set up level
	level_instance_during_transition.initialize()
	
	previous_level = current_level
	current_level = level_instance_during_transition
	current_level_idx = new_level_idx_after_transition
	last_transition_direction = level_change_direction_after_transition
	level_changed.emit(new_level_idx_after_transition)
	
	# TODO: WARNING: THIS IS SPAGHETTI CODE! FIX AS SOON AS POSSIBLE!
	if should_save_after_transition:
		SaveManager.level_changed(new_level_idx_after_transition)
	print("Emitted level changed signal")
	world_state = WorldState.NORMAL
