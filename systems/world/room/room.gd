class_name Room extends Node2D

signal room_door_entered(dest_room_path: String, dest_door_tag: String)

@onready var camera_bounds: CollisionShape2D = $CameraBounds/CollisionShape2D

func _ready() -> void:
	
	# Attach signals to all of the doors
	
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		door.door_entered.connect(door_entered)

func door_entered(dest_room_path: String, dest_door_tag: String):
	room_door_entered.emit.call_deferred(dest_room_path, dest_door_tag)

func get_camera_bounds() -> Rect2:
	
	var shape: Shape2D = camera_bounds.shape
	
	if shape is RectangleShape2D:
		var x: float = camera_bounds.global_position.x
		var y: float = camera_bounds.global_position.y
		var w: float = shape.size.x
		var h: float = shape.size.y
		
		return Rect2(x, y, w, h)
	
	return Rect2(0, 0, 0, 0)
