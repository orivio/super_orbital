class_name RoomManager
extends Node

signal room_changed(room: String)

@export var initial_room: String = ""
@export var initial_door_ta: String
@export var room_transition_time: float

var current_room: Node2D = null
var previous_room: Node2D = null
var current_room_path: String
var last_entered_door_tag: String

@onready var player: Player = $Player
@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var fade: Fade = $Fade
@onready var room_container: Node2D = $RoomContainer

func _ready() -> void:
	room_changed.connect(SaveManager._on_room_changed)
	player.player_death.connect(_on_player_death)

func _on_player_death() -> void:
	reload_room()

func reload_room() -> void:
	change_room(current_room_path, last_entered_door_tag, false)

func load_initial_room() -> void:
	if initial_room == "":
		initial_room = SaveManager.get_save_file().room
	# print(initial_door_ta)
	# print(initial_room_path)
	fade.color_rect.color = Color(0, 0, 0, 1)
	change_room(initial_room, initial_door_ta, false)
	player.load_abilities()

func change_room(dest_room: String, dest_door_tag: String, do_save: bool = true) -> void:
	
	if not GameManager.room_exists(dest_room):
		push_error("Room does not exist: ", dest_room)
		return
	
	# print(dest_room)
	
	# print("Disabling player")
	player.disable_physics()
	
	await fade.fade(Color(0, 0, 0, 1), room_transition_time).finished
	
	# First, load the room resource
	
	var room_resource = GameManager.get_room(dest_room)
	if not room_resource:
		push_error("Failed to load room: ", dest_room)
		return
	
	# Now we instantiate it
	
	var room_instance = room_resource.instantiate()
	
	# Remove old room
	
	if current_room:
		previous_room = current_room
		current_room.queue_free()
	
	
	# Add new room
	
	room_container.add_child(room_instance)
	current_room = room_instance
	current_room.initialize_room()
	GameManager.current_room = current_room
	current_room.room_door_entered.connect(change_room)
	
	
	if previous_room:
		await previous_room.tree_exited
		await get_tree().process_frame
	
	if dest_door_tag:
		teleport_player_to_door(current_room, dest_door_tag)
		last_entered_door_tag = dest_door_tag
	# print("Teleported player")
	
	current_room_path = dest_room
	
	update_camera_limits(room_instance)
	
	# print("Enabling player")
	player.enable_physics()
	
	await fade.fade(Color(0, 0, 0, 0), room_transition_time).finished
	
	if do_save and GameManager.room_exists(dest_room):
		room_changed.emit(dest_room)
	
	GameManager.player_leave_blackhole()
	
	if current_room.music_for_this_room != "":
		AudioManager.change_music(current_room.music_for_this_room)

func teleport_player_to_door(room: Room, dest_door_tag: String):
	
	# print("Teleporting player to door: ", dest_door_tag, " in room: ", room)
	
	# Find the right door
	
	var doors = room.get_doors()
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
			
			# Reset player momentum
			
			# player.direction = 0
			# player.velocity = Vector2.ZERO
			
			# print("Teleporting to: ", player.global_position)
			
			return
	
	print("Could not find door ", dest_door_tag, " in room ", room.name)

func update_camera_limits(room: Room) -> void:
	
	# Adjust camera limits based on what the room says it's limits are
	
	var camera_bounds: Rect2 = room.get_camera_bounds()
	
	player_camera.set_limits(camera_bounds)
