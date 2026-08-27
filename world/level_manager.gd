class_name LevelManager
extends Node

signal door_entered(direction: Types.DoorDirection)
signal level_changed(level: String, level_uid: String)

@export var initial_level: String = ""
@export var initial_door_ta: String
@export var level_transition_time: float

var current_level: Node2D = null
var previous_level: Node2D = null
var current_level_path: String
var last_entered_door_tag: String

@onready var player: Player = $Player
@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var fade_effect: FadeEffect = $FadeEffect
@onready var level_container: Node2D = $LevelContainer

func _ready() -> void:
	level_changed.connect(SaveManager._on_level_changed)
	player.player_death.connect(_on_player_death)

func _on_player_death() -> void:
	reload_level()

func reload_level() -> void:
	change_level(current_level_path, last_entered_door_tag, false)

func initialize() -> void:
	if initial_level == "":
		initial_level = SaveManager.get_save_file().level_uid
	# print(initial_door_ta)
	# print(initial_level_path)
	fade_effect.color_rect.color = Color(0, 0, 0, 1)
	change_level(initial_level, initial_door_ta, false)
	player.load_abilities()

func change_level(level_scene_path: String, dest_door_tag: String, do_save: bool = true) -> void:
	
	var previous_music: String = ""
	if current_level:
		previous_music = current_level.music_for_this_level
	# print(dest_level)
	
	# print("Disabling player")
	player.disable_physics()
	
	await fade_effect.fade(Color(0, 0, 0, 1), level_transition_time).finished
	
	# First, load the level resource
	
	var level_resource = load(level_scene_path)
	if not level_resource:
		push_error("Failed to load level: ", level_scene_path)
		return
	
	# Now we instantiate it
	
	var level_instance = level_resource.instantiate()
	
	# Remove old level
	
	if current_level:
		previous_level = current_level
		current_level.queue_free()
	
	
	# Add new level
	
	level_container.add_child(level_instance)
	current_level = level_instance
	current_level.initialize_level()
	GameManager.current_level = current_level
	current_level.door_entered.connect(_on_door_entered)
	
	
	if previous_level:
		await previous_level.tree_exited
		await get_tree().process_frame
	
	if dest_door_tag:
		teleport_player_to_door(current_level, dest_door_tag)
		last_entered_door_tag = dest_door_tag
	# print("Teleported player")
	
	current_level_path = level_scene_path
	
	update_camera_limits(level_instance)
	
	# print("Enabling player")
	player.enable_physics()
	
	await fade_effect.fade(Color(0, 0, 0, 0), level_transition_time).finished
	
	if do_save and GameManager.level_exists(level_scene_path):
		level_changed.emit(level_scene_path, level_scene_path)
	
	GameManager.player_leave_blackhole()
	if current_level.music_for_this_level != "" and current_level.music_for_this_level != previous_music:
		AudioManager.change_music(current_level.music_for_this_level)

func teleport_player_to_door(level: Level, dest_door_tag: String):
	
	# print("Teleporting player to door: ", dest_door_tag, " in level: ", level)
	
	# Find the right door
	
	var doors = level.get_doors()
	for door in doors:
		if "door_tag" in door and door.door_tag == dest_door_tag:
			
			# We can teleport the player to the door's spawn
			
			var spawn_location = door.spawn.global_position
			
			# Raycast to make sure player snaps to the ground
			# WARNING: Potentially buggy
			
			player.has_gravity = true
			
			#player.global_position = collision.position + player.get_half_height() * Vector2.UP
			
			player.teleport_to_ground(spawn_location)
			player.reset()
			GameManager.camera.snap_camera_to_player()
			
			# Reset player momentum
			
			# player.direction = 0
			# player.velocity = Vector2.ZERO
			
			# print("Teleporting to: ", player.global_position)
			
			return
	
	print("Could not find door ", dest_door_tag, " in level ", level.name)

func update_camera_limits(level: Level) -> void:
	
	# Adjust camera limits based on what the level says it's limits are
	
	var camera_bounds: Rect2 = level.get_camera_bounds()
	
	player_camera.set_limits(camera_bounds)


func do_level_transition(direction: Types.DoorDirection) -> void:
	var current_level_idx: int = GameManager.levels.values().find(current_level_path)
	var new_level_idx: int = current_level_idx + direction
	var new_level_path: String = GameManager.levels.get(GameManager.levels.keys()[new_level_idx])
	match direction:
		Types.DoorDirection.WEST:
			await change_level(new_level_path, "EastDoor", true)
		Types.DoorDirection.EAST:
			await change_level(new_level_path, "WestDoor", true)

func _on_door_entered(direction: Types.DoorDirection) -> void:
	door_entered.emit(direction)
