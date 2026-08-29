class_name LevelManager
extends Node

signal door_entered(direction: Types.DoorDirection)
signal level_changed(level_idx: int)

const LEVEL_DIR: LevelDirectory = preload("res://world/level_directory.tres")

@export var level_transition_time: float

var current_level: Node2D = null
var previous_level: Node2D = null
var current_level_idx: int
var current_level_meta: LevelMeta
var previous_level_meta: LevelMeta
var last_entered_door: String

@onready var player: Player = $Player
@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var fade_effect: FadeEffect = $FadeEffect
@onready var level_container: Node2D = $LevelContainer


func _ready() -> void:
	# Connect signals
	level_changed.connect(SaveManager._on_level_changed)
	player.player_death.connect(_on_player_death)
	# Prepare the fade to black effect
	#fade_effect.color_rect.color = Color(0, 0, 0, 1)


func initialize() -> void:
	# Get the level number from the save file
	var level_idx: int = SaveManager.get_save_file().level_idx
	# Get the level metadata from the 
	var level_meta: LevelMeta = LEVEL_DIR.get_level_meta(level_idx)
	# Change the level
	change_level(level_meta, "WestDoor")
	current_level_idx = level_idx
	# Get the player ready
	player.initialize()


func reload_level() -> void:
	# Change level to the current level, at the door you last entered
	change_level(current_level_meta, last_entered_door)


func change_level(new_level_meta: LevelMeta, dest_door: String) -> void:
	# No physics collisions while transitioning levels!
	#player.disable_physics()
	
	# Do the fade to black
	#await fade_effect.fade(Color(0, 0, 0, 1), level_transition_time).finished
	
	# Load the level scene
	var level_scene_path: String = new_level_meta.scene_path
	var level_scene: PackedScene = load(level_scene_path)
	if not level_scene:
		push_error("Failed to load level: ", new_level_meta.level_name)
		return
	
	# Now we instantiate it
	var level_instance: Level = level_scene.instantiate()
	
	# Remove old level
	if current_level:
		previous_level = current_level
		current_level.queue_free()
	
	# Add new level
	level_container.add_child(level_instance)
	current_level = level_instance
	# Set up level
	current_level.initialize()
	GameManager.current_level = current_level
	current_level.door_entered.connect(_on_door_entered)
	
	# Destroy the old level
	if previous_level:
		await previous_level.tree_exited
	
	# Teleport the player to the door
	if dest_door:
		teleport_player_to_door(current_level, dest_door)
		last_entered_door = dest_door
	
	# Update level metadata
	previous_level_meta = current_level_meta
	current_level_meta = new_level_meta
	
	# Update camera limits
	update_camera_limits(level_instance)
	# Reenable physics
	#player.enable_physics()
	# Fade out from black
	#await fade_effect.fade(Color(0, 0, 0, 0), level_transition_time).finished
	# Update physics
	GameManager.player_leave_blackhole()
	# Update music
	if current_level_meta.song != &"" and (not previous_level_meta or current_level_meta.song != previous_level_meta.song):
		AudioManager.change_music(current_level_meta.song)


func teleport_player_to_door(level: Level, dest_door_tag: String):
	# Find the right door
	var doors = level.get_doors()
	for door in doors:
		if door is Door and door.door_tag == dest_door_tag:
			# We can teleport the player to the door's spawn position
			var spawn_location: Vector2 = door.get_spawn_pos()
			
			# Teleport the player and reset everything
			player.teleport_to_ground(spawn_location)
			player.reset()
			GameManager.camera.snap_camera_to_player()
			return
	
	print("Could not find door ", dest_door_tag, " in level ", level.name)


func update_camera_limits(level: Level) -> void:
	# Adjust camera limits based on what the level says it's limits are
	var camera_bounds: Rect2 = level.get_camera_bounds()
	player_camera.set_limits(camera_bounds)


func do_level_transition(direction: Types.DoorDirection) -> void:
	# Find next level to go to
	var new_level_idx: int = current_level_idx + direction
	var new_level_meta: LevelMeta = LEVEL_DIR.get_level_meta(new_level_idx)
	
	# Change level, and make the player go to the opposite side door
	match direction:
		Types.DoorDirection.WEST:
			await change_level(new_level_meta, "EastDoor")
		Types.DoorDirection.EAST:
			await change_level(new_level_meta, "WestDoor")
	
	# Finish up
	current_level_idx = new_level_idx
	level_changed.emit(new_level_idx)


func _on_door_entered(direction: Types.DoorDirection) -> void:
	door_entered.emit(direction)


func _on_player_death() -> void:
	# TODO: Add checkpoints
	reload_level()
