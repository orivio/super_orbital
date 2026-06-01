class_name RoomManager extends Node

@export_file("*.tscn") var initial_room_path: String
@export var initial_door_tag: String

var current_room: Node2D = null

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
		current_room.queue_free()
	
	# Add new room
	
	add_child(room_instance)
	current_room = room_instance
	current_room.room_door_entered.connect(change_room)
	
	if dest_door_tag:
		teleport_player_to_door(dest_door_tag)
	
	update_camera_limits(room_instance)

func teleport_player_to_door(dest_door_tag: String):
	
	# Find the right door
	
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		if "door_tag" in door and door.door_tag == dest_door_tag:
			
			# We can teleport the player to the door's spawn
			
			var spawn_location = door.spawn.global_position
			
			player.global_position = spawn_location
			
			return

func update_camera_limits(room: Room) -> void:
	
	# Adjust camera limits based on what the room says it's limits are
	
	var camera_bounds: Rect2 = room.get_camera_bounds()
	
	player_camera.set_limits(camera_bounds)
