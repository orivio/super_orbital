class_name RoomManager extends Node

@export_file("*.tscn") var initial_room_path: String
@export var initial_door_tag: String

var current_room: Node2D = null
var previous_room: Node2D = null

@onready var player: Node2D = $Player
@onready var player_camera: PlayerCamera = $PlayerCamera

func _ready() -> void:
	call_deferred("load_initial_room")

func load_initial_room() -> void:
	change_room(initial_room_path, initial_door_tag)

func change_room(dest_room_path: String, dest_door_tag: String) -> void:
	
	# First, load the room resource
	
	var room_resource = load(dest_room_path)
	if not room_resource:
		push_error("Failed to load room: ", dest_room_path)
		return
	
	# Now we instantiate it
	
	var room_instance = room_resource.instantiate()
	
	# Remove old room
	
	if current_room:
		previous_room = current_room
		current_room.queue_free()
	
	# Add new room
	
	add_child(room_instance)
	current_room = room_instance
	current_room.room_door_entered.connect(change_room)
	
	if previous_room:
		await previous_room.tree_exited
		await get_tree().process_frame
	
	if dest_door_tag:
		teleport_player_to_door(current_room, dest_door_tag)
	
	update_camera_limits(room_instance)

func teleport_player_to_door(room: Room, dest_door_tag: String):
	
	# Find the right door
	
	var doors = room.get_doors()
	for door in doors:
		if "door_tag" in door and door.door_tag == dest_door_tag:
			
			# We can teleport the player to the door's spawn
			
			var spawn_location = door.spawn.global_position
			
			# Raycast to make sure player snaps to the ground
			# WARNING: Potentially buggy
			
			var query = PhysicsRayQueryParameters2D.create(spawn_location, spawn_location + Vector2(0, 40000))
			var collision: Dictionary = get_viewport().find_world_2d().direct_space_state.intersect_ray(query)
			
			player.has_gravity = true # not working, state doesnt change
			
			if collision:
				player.global_position = collision.position
			else:
				player.global_position = spawn_location
			
			# Reset player momentum
			
			# player.direction = 0
			# player.velocity = Vector2.ZERO
			
			return

func update_camera_limits(room: Room) -> void:
	
	# Adjust camera limits based on what the room says it's limits are
	
	var camera_bounds: Rect2 = room.get_camera_bounds()
	
	player_camera.set_limits(camera_bounds)
